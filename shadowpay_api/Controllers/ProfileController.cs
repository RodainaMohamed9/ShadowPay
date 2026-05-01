using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using shadowpay_api.Data;
using shadowpay_api.Services;

namespace shadowpay_api.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ProfileController : ControllerBase
    {
        private readonly ICurrentUserService _currentUser;
        private readonly AppDbContext _db;

        public ProfileController(ICurrentUserService currentUser, AppDbContext db)
        {
            _currentUser = currentUser;   
            _db = db;
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

            var profileData = new
            {
                FullName = user.FullName,
                CardNumberHash = user.CardNumberHash,
                CardHolderName = user.CardHolderName,
                ExprDate = user.ExprDate,
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,
            };
            return Ok(profileData);
        }
    }
}
