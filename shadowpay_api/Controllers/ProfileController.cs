using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using shadowpay_api.Data;
using shadowpay_api.ModelVM.AccountVM;
using shadowpay_api.Services;
using shadowpay_api.Services.Implements;

namespace shadowpay_api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ProfileController : ControllerBase
    {
        private readonly ICurrentUserService _currentUser;
        private readonly AppDbContext _db;
        private readonly BankService _bankService;

        public ProfileController(ICurrentUserService currentUser, AppDbContext db, BankService bankService)
        {
            _currentUser = currentUser;   
            _db = db;
            _bankService = bankService;
        }

        [HttpGet("get-profile")]
        public async Task<IActionResult> GetProfile()
        {
            var currentUserId = _currentUser.UserId;

            if (String.IsNullOrEmpty(currentUserId))
                return Unauthorized();

            var user = await _db.Users.FindAsync(currentUserId);

            if (user == null)
                return NotFound(new { message = "User not found" });

            var bankInfo = await _bankService.JavaIntegrationService(new RegisterVM
            {
                CardNumberHash = user.CardNumberHash,
                ExprDate = user.ExprDate, 
                PhoneNumber = user.PhoneNumber
            });
            var profileData = new
            {
                FullName = user.FullName,
                CardNumberHash = user.CardNumberHash,
                CardHolderName = user.CardHolderName,
                ExprDate = user.ExprDate,
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,

                Balance = bankInfo.balance,
                IsFrozen = bankInfo.isFrozen,
                CardType = bankInfo.cardType,
            };
            return Ok(profileData);
        }
    }
}
