using System.Text.Json.Nodes;
using shadowpay_api.ModelVM;
using shadowpay_api.ModelVM.AccountVM; 

namespace shadowpay_api.Services.Implements
{
    public class BankService
    {
        public async Task<JavaResponse> JavaIntegrationService(RegisterVM register)
        {
            using var client = new HttpClient();

            var javaLoad = new
            {
                cardNumber = register.CardNumberHash, 
                exprDate = register.ExprDate.ToString("yyyy-MM-dd"),
                phoneNumber = register.PhoneNumber
            };

            var response = await client.PostAsJsonAsync("http://localhost:8080/api/validate", javaLoad);

            var rawJson = await response.Content.ReadAsStringAsync();
            Console.WriteLine(rawJson);

            if (!response.IsSuccessStatusCode)
            {
                return new JavaResponse { isExist = false, isActive = false, isExpired = true, isBlocked = true, isPhoneMatched = false, isExpiryMatched = false };
            }

            var jsonNode = JsonNode.Parse(rawJson);

            return new JavaResponse
            {
                isExist = jsonNode["exist"]?.GetValue<bool>() ?? jsonNode["isExist"]?.GetValue<bool>() ?? false,
                isActive = jsonNode["active"]?.GetValue<bool>() ?? jsonNode["isActive"]?.GetValue<bool>() ?? false,
                isExpired = jsonNode["expired"]?.GetValue<bool>() ?? jsonNode["isExpired"]?.GetValue<bool>() ?? true,
                isBlocked = jsonNode["blocked"]?.GetValue<bool>() ?? jsonNode["isBlocked"]?.GetValue<bool>() ?? true,
                isPhoneMatched = jsonNode["phoneMatched"]?.GetValue<bool>() ?? jsonNode["isPhoneMatched"]?.GetValue<bool>() ?? false,
                isExpiryMatched = jsonNode["expiryMatched"]?.GetValue<bool>() ?? jsonNode["isExpiryMatched"]?.GetValue<bool>() ?? false
            };
        }
    }
}