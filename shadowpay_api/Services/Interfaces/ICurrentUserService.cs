using System.Security.Claims;

namespace shadowpay_api.Services
{
    public interface ICurrentUserService
    {
        public string UserId { get; }
    }
}
