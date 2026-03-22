using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.IdentityModel.Tokens;
using shadowpay_api.Models;
using shadowpay_api.ModelVM.AccountVM;

namespace shadowpay_api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AccountController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> userManager;
        private readonly SignInManager<ApplicationUser> signInManager;
        private readonly IConfiguration configuration;
        private readonly EmailService emailService;
        private readonly IMemoryCache memoryCache;


        public AccountController(
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            IConfiguration configuration,
            EmailService emailService,
            IMemoryCache memoryCache)
        {
            this.userManager = userManager;
            this.signInManager = signInManager;
            this.configuration = configuration;
            this.emailService = emailService;
            this.memoryCache = memoryCache;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterVM model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (model.Password != model.ConfirmPassword)
                return BadRequest("Passwords do not match"); 

            var user = new ApplicationUser
            {
                UserName = model.Email,
                Email = model.Email,
                FullName = model.FullName,
                PhoneNumber = model.PhoneNumber,
                CardNumberHash = model.CardNumberHash,
                CardHolderName = model.CardHolderName,
                ExprDate = model.ExprDate
            };

            var result = await userManager.CreateAsync(user, model.Password);

            if (result.Succeeded)
            {
                return Ok(new
                {
                    message = "User Created Successfully"
                });
            }

            return BadRequest(new
            {
                errors = result.Errors.Select(e => e.Description)
            });
        }
        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginVM model)
        {
            var user = await userManager.FindByEmailAsync(model.Email);

            if (user == null)
                return Unauthorized(new { message = "Invalid Email or Password" });

            var result = await signInManager.CheckPasswordSignInAsync(user, model.Password, false);

            if (!result.Succeeded)
                return Unauthorized(new { message = "Invalid Email or Password" });

            var authClaims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.Email),
                new Claim(ClaimTypes.NameIdentifier, user.Id)
            };

            var authSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(configuration["JWT:Key"])
            );

            var token = new JwtSecurityToken(
                issuer: configuration["JWT:Issuer"],
                audience: configuration["JWT:Audience"],
                expires: DateTime.Now.AddMinutes(
                    double.Parse(configuration["JWT:DurationInMinutes"])
                ),
                claims: authClaims,
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)
            );

            return Ok(new
            {
                token = new JwtSecurityTokenHandler().WriteToken(token),
                expiration = token.ValidTo
            });
        }

        [HttpPost("send-otp")]
        public async Task<IActionResult> SendOTP([FromQuery] string email)
        {
            var user = await userManager.FindByEmailAsync(email);

            if (user == null)
                return BadRequest("User not found");

            var otp = GenerateOTP();

            memoryCache.Set($"OTP_{email}", otp, TimeSpan.FromMinutes(5));

            await emailService.SendOTP(user.Email, otp);

            return Ok("OTP sent to your email");
        }

        [HttpPost("verify-otp")]
        public IActionResult VerifyOTP(string email, string otp)
        {
            if (memoryCache.TryGetValue($"OTP_{email}", out string? cachedOtp) && cachedOtp == otp)
            {
                memoryCache.Remove($"OTP_{email}");
                return Ok("OTP Verified Successfully");
            }

            return BadRequest("Invalid or expired OTP");
        }

        private string GenerateOTP()
        {
            var random = new Random();
            return random.Next(100000, 999999).ToString();
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword(ResetPasswordVM model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (model.NewPassword != model.ConfirmPassword)
                return BadRequest("Passwords do not match");

            if (!memoryCache.TryGetValue($"OTP_{model.Email}", out string? cachedOtp) || cachedOtp != model.OTP)
                return BadRequest("Invalid or expired OTP");

            var user = await userManager.FindByEmailAsync(model.Email);
            if (user == null)
                return BadRequest("User not found");

            var token = await userManager.GeneratePasswordResetTokenAsync(user);
            var result = await userManager.ResetPasswordAsync(user, token, model.NewPassword);

            if (!result.Succeeded)
                return BadRequest(new { errors = result.Errors.Select(e => e.Description) });

            memoryCache.Remove($"OTP_{model.Email}");

            return Ok("Password has been reset successfully");
        }
    }
}
