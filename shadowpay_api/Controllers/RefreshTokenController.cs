using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Linq;
using shadowpay_api.Data;
using shadowpay_api.Models;
using shadowpay_api.ModelVM;
using shadowpay_api.Services;
using shadowpay_api.Services.Implements;

namespace shadowpay_api.Controllers
{
    [ApiController]
    [Route("/api/[controller]")]
    public class RefreshTokenController : ControllerBase
    {
        private readonly AppDbContext _db;
        private readonly TokenService tokenService;
        public RefreshTokenController(AppDbContext _db, TokenService tokenService)
        {
            this._db = _db;
            this.tokenService = tokenService;
        }
        [HttpPost("refresh-token")]
        public async Task<IActionResult> GetRefreshToken([FromBody] TokenVM model)
        {
            if (string.IsNullOrEmpty(model.Token))
                return BadRequest("Token is required");

            var currentRefreshToken = await _db.RefreshTokens.FirstOrDefaultAsync(t => t.Token == model.Token);
            if (currentRefreshToken == null || !currentRefreshToken.IsActive)
            {
                return Unauthorized();
            }

            else
            {
                var userId = currentRefreshToken.UserId;
                var user = await _db.Users.FirstOrDefaultAsync(u => u.Id == userId);
                if (user == null)
                {
                    return Unauthorized();
                }

                var token = await tokenService.CreateTokens(user);


                return Ok(new
                {

                    AccessToken = token.AccessToken,
                    AccessTokenExpiration = token.AccessTokenExpiration,

                    RefreshToken = token.RefreshToken,
                    RefreshTokenExpiration = token.RefreshTokenExpiration
                });
            }
        }
    }
}
