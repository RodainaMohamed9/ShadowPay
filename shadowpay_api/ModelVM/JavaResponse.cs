
using System.Text.Json.Serialization;

namespace shadowpay_api.ModelVM
{
    public class JavaResponse
    {
        [JsonPropertyName("exist")]
        public bool isExist { get; set; }

        [JsonPropertyName("active")]
        public bool isActive { get; set; }

        [JsonPropertyName("expired")]
        public bool isExpired { get; set; }

        [JsonPropertyName("blocked")]
        public bool isBlocked { get; set; }

        [JsonPropertyName("phoneMatched")]
        public bool isPhoneMatched { get; set; }

        [JsonPropertyName("expiryMatched")]
        public bool isExpiryMatched { get; set; }
    }
}
