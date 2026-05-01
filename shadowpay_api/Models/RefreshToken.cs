using Microsoft.EntityFrameworkCore;

namespace shadowpay_api.Models
{
    public class RefreshToken
    {
        public int Id { get; set; }
        public string Token { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ExpiredDate { get; set; }
        public DateTime? RevokedOn { get; set; }

        public string UserId { get; set; }
        public ApplicationUser User { get; set; }

        public bool IsExpired => DateTime.UtcNow >= ExpiredDate;
        public bool IsActive => RevokedOn == null && !IsExpired;
    }
}
