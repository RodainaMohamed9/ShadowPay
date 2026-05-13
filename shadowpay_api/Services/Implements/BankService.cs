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

            var response = await client.PostAsJsonAsync("http://localhost:8081/api/validate", javaLoad);

            var rawJson = await response.Content.ReadAsStringAsync();
            Console.WriteLine(rawJson);

            if (!response.IsSuccessStatusCode)
            {
                return new JavaResponse { isExist = false, isActive = false, isExpired = true, isBlocked = true, isPhoneMatched = false, isExpiryMatched = false, isFrozen = true };
            }

            var jsonNode = JsonNode.Parse(rawJson);

            return new JavaResponse
            {
                isExist = jsonNode["exist"]?.GetValue<bool>() ?? jsonNode["isExist"]?.GetValue<bool>() ?? false,
                isActive = jsonNode["active"]?.GetValue<bool>() ?? jsonNode["isActive"]?.GetValue<bool>() ?? false,
                isExpired = jsonNode["expired"]?.GetValue<bool>() ?? jsonNode["isExpired"]?.GetValue<bool>() ?? true,
                isBlocked = jsonNode["blocked"]?.GetValue<bool>() ?? jsonNode["isBlocked"]?.GetValue<bool>() ?? true,
                isFrozen = jsonNode["frozen"]?.GetValue<bool>() ?? false,
                isPhoneMatched = jsonNode["phoneMatched"]?.GetValue<bool>() ?? jsonNode["isPhoneMatched"]?.GetValue<bool>() ?? false,
                isExpiryMatched = jsonNode["expiryMatched"]?.GetValue<bool>() ?? jsonNode["isExpiryMatched"]?.GetValue<bool>() ?? false,
                balance = jsonNode["balance"]?.GetValue<decimal>() ?? 0m,
                cardType = jsonNode["cardType"]?.GetValue<string>() ?? "VISA"
            };
        }

        public async Task<bool> ToggleFreezeStatusInJava(string cardNumber)
        {
            using var client = new HttpClient();

            var requestData = new { cardNumber = cardNumber };

            var response = await client.PostAsJsonAsync("http://localhost:8081/api/toggle-freeze", requestData);

            if (response.IsSuccessStatusCode)
            {
                var rawJson = await response.Content.ReadAsStringAsync();
                var jsonNode = JsonNode.Parse(rawJson);

                return jsonNode["success"]?.GetValue<bool>() ?? false;
            }

            return false;
        }
    }
}