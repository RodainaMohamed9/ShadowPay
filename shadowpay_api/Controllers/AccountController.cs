using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.IdentityModel.Tokens;
using shadowpay_api.Data;
using shadowpay_api.Migrations;
using shadowpay_api.Models;
using shadowpay_api.ModelVM.AccountVM;
using shadowpay_api.Services.Implements;

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
        private readonly TokenService tokenService;
        private readonly AppDbContext _db;


        public AccountController(
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            IConfiguration configuration,
            EmailService emailService,
            IMemoryCache memoryCache,
            TokenService tokenService,
            AppDbContext _db

            )
        {
            this.userManager = userManager;
            this.signInManager = signInManager;
            this.configuration = configuration;
            this.emailService = emailService;
            this.memoryCache = memoryCache;
            this.tokenService = tokenService;
            this._db = _db;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterVM model)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values
                        .SelectMany(v => v.Errors)
                        .Select(e => e.ErrorMessage)
                        .ToList();

                    return BadRequest(new
                    {
                        success = false,
                        errors = errors
                    });
                }

                var existingUser = await userManager.FindByEmailAsync(model.Email);
                if (existingUser != null)
                {
                    return BadRequest(new
                    {
                        success = false,
                        errors = new[] { "Email already exists. Please use a different email." }
                    });
                }

                var tempUserData = new OtpRequestVM
                {
                    Email = model.Email,
                    FullName = model.FullName,
                    PhoneNumber = model.PhoneNumber,
                    Password = model.Password,
                    CardNumberHash = model.CardNumberHash,
                    CardHolderName = model.CardHolderName,
                    ExprDate = model.ExprDate,
                    Purpose = "register"
                };

                memoryCache.Set($"REGISTER_{model.Email}", tempUserData, TimeSpan.FromMinutes(10));

                var otp = GenerateOTP();
                memoryCache.Set($"OTP_{model.Email}", otp, TimeSpan.FromMinutes(5));

                await emailService.SendOTP(model.Email, otp);

                return Ok(new
                {
                    success = true,
                    message = "OTP sent to your email. Please verify to complete registration.",
                    requireOtp = true
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Registration error: {ex.Message}");
                return StatusCode(500, new
                {
                    success = false,
                    errors = new[] { "An internal error occurred. Please try again later." }
                });
            }
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginVM model)
        {
            var user = await userManager.FindByEmailAsync(model.Email);

            if (user == null)
                return Unauthorized(new { message = "Invalid email or password" });

            var result = await signInManager.CheckPasswordSignInAsync(user, model.Password, false);

            if (!result.Succeeded)
                return Unauthorized(new { message = "Invalid email or password" });

            var token = await tokenService.CreateTokens(user);
            

            return Ok(new
            {

                AccessToken = token.AccessToken,
                AccessTokenExpiration = token.AccessTokenExpiration,

                RefreshToken = token.RefreshToken,
                RefreshTokenExpiration = token.RefreshTokenExpiration
            });
        }

        [HttpPost("send-otp")]
        public async Task<IActionResult> SendOTP([FromBody] OtpRequestVM model)
        {
            if (model.Purpose == "register")
            {
                var existingUser = await userManager.FindByEmailAsync(model.Email);
                if (existingUser != null)
                    return BadRequest(new { success = false, message = "Email already exists." });

                memoryCache.Set($"REGISTER_{model.Email}", model, TimeSpan.FromMinutes(10));
            }
            else if (model.Purpose == "forgot")
            {
                var existingUser = await userManager.FindByEmailAsync(model.Email);
                if (existingUser == null)
                    return BadRequest(new { success = false, message = "Email not found." });
            }
            else
            {
                return BadRequest(new { success = false, message = "Invalid purpose." });
            }

            var otp = GenerateOTP();
            memoryCache.Set($"OTP_{model.Email}", otp, TimeSpan.FromMinutes(5));

            await emailService.SendOTP(model.Email, otp);

            return Ok(new { success = true, message = "OTP sent." });
        }

        [HttpPost("verify-otp")]
        public async Task<IActionResult> VerifyOTP([FromBody] OtpVerifyVM model)
        {
            if (!memoryCache.TryGetValue($"OTP_{model.Email}", out string? cachedOtp) || cachedOtp != model.OTP)
                return BadRequest(new { success = false, message = "Invalid or expired OTP" });

            if (model.Purpose == "register")
            {
                memoryCache.Remove($"OTP_{model.Email}");

                if (!memoryCache.TryGetValue($"REGISTER_{model.Email}", out OtpRequestVM? tempUserData))
                    return BadRequest(new { success = false, message = "Registration data expired. Please try again." });

                var user = new ApplicationUser
                {
                    UserName = tempUserData.Email,
                    Email = tempUserData.Email,
                    FullName = tempUserData.FullName,
                    PhoneNumber = tempUserData.PhoneNumber,
                    CardNumberHash = tempUserData.CardNumberHash,
                    CardHolderName = tempUserData.CardHolderName,
                    ExprDate = tempUserData.ExprDate ?? DateTime.Now
                };

                var result = await userManager.CreateAsync(user, tempUserData.Password);
                memoryCache.Remove($"REGISTER_{model.Email}");

                if (!result.Succeeded)
                    return BadRequest(new { success = false, errors = result.Errors.Select(e => e.Description) });

                return Ok(new { success = true, message = "Registration completed!" });
            }
            else if (model.Purpose == "forgot")
            {
                return Ok(new { success = true, message = "OTP verified! You can reset your password now." });
            }

            return BadRequest(new { success = false, message = "Invalid purpose." });
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
                return BadRequest(new { success = false, errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage) });

            if (model.NewPassword != model.ConfirmPassword)
                return BadRequest(new { success = false, message = "Passwords do not match" });

            if (!memoryCache.TryGetValue($"OTP_{model.Email}", out string? cachedOtp) || cachedOtp != model.OTP)
                return BadRequest(new { success = false, message = "Invalid or expired OTP" });

            var user = await userManager.FindByEmailAsync(model.Email);
            if (user == null)
                return BadRequest(new { success = false, message = "User not found" });

            var token = await userManager.GeneratePasswordResetTokenAsync(user);
            var result = await userManager.ResetPasswordAsync(user, token, model.NewPassword);

            if (!result.Succeeded)
                return BadRequest(new { success = false, errors = result.Errors.Select(e => e.Description) });

            memoryCache.Remove($"OTP_{model.Email}");

            return Ok(new { success = true, message = "Password has been reset successfully" });
        }
    }
}
