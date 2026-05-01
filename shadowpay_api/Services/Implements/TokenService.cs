using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using shadowpay_api.Data;
using shadowpay_api.Migrations;
using shadowpay_api.Models;

namespace shadowpay_api.Services.Implements
{
    public class TokenResult
    {
        public string AccessToken { get; set; }
        public DateTime AccessTokenExpiration { get; set; }

        public string RefreshToken { get; set; }
        public DateTime RefreshTokenExpiration { get; set; }
    }
    public class TokenService
    {
        private readonly IConfiguration configuration;
        private readonly AppDbContext _db;


        public TokenService(IConfiguration configuration, AppDbContext _db)
        {
            this.configuration = configuration;
            this._db = _db;
        }

        public TokenResult GenerateAccessToken(ApplicationUser user)
        {
            var authClaims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.Email ?? ""),
                new Claim(ClaimTypes.NameIdentifier, user.Id),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            };

            var authSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(configuration["JWT:Key"])
            );

            var expiration = DateTime.UtcNow.AddMinutes(
                double.Parse(configuration["JWT:DurationInMinutes"])
            );

            var token = new JwtSecurityToken(
                issuer: configuration["JWT:Issuer"],
                audience: configuration["JWT:Audience"],
                expires: expiration,
                claims: authClaims,
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)
            );

            return new TokenResult
            {
                AccessToken = new JwtSecurityTokenHandler().WriteToken(token),
                AccessTokenExpiration = expiration
            };
        }

        public RefreshToken GenerateRefreshToken()
        {
            var randomNumber = RandomNumberGenerator.GetBytes(32);

            return new RefreshToken
            {
                Token = Convert.ToBase64String(randomNumber),
                ExpiredDate = DateTime.UtcNow.AddDays(10),
                CreatedOn = DateTime.UtcNow,
            };
        }

        public async Task<TokenResult> CreateTokens(ApplicationUser user)
        {
            var accessTokenResult = GenerateAccessToken(user);

            

            var oldTokens = await _db.RefreshTokens
                .Where(x => x.UserId == user.Id && x.RevokedOn == null)
                .ToListAsync();

            foreach (var t in oldTokens)
            {
                t.RevokedOn = DateTime.UtcNow;
            }

            var newRefreshToken = GenerateRefreshToken();
            newRefreshToken.UserId = user.Id;

            await _db.RefreshTokens.AddAsync(newRefreshToken);

            await _db.SaveChangesAsync();

            return new TokenResult
            {
                AccessToken = accessTokenResult.AccessToken,
                AccessTokenExpiration = accessTokenResult.AccessTokenExpiration,

                RefreshToken = newRefreshToken.Token,
                RefreshTokenExpiration = newRefreshToken.ExpiredDate
            };
        }
    }
}