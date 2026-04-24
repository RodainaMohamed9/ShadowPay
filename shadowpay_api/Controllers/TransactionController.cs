
using System.Linq;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using shadowpay_api.Data;
using shadowpay_api.Enums;
using shadowpay_api.Models;
using shadowpay_api.ModelVM.TransactionVM;
using shadowpay_api.Services;


namespace shadowpay_api.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class TransactionController : ControllerBase
    {
        private readonly AppDbContext _db;
        private readonly ICurrentUserService _currentUser;
        public TransactionController(AppDbContext db, ICurrentUserService currentUserService)
        {
            _db = db;
            _currentUser = currentUserService;
        }
        [HttpGet("transaction-list")]
        public async Task<ActionResult<IEnumerable<Transaction>>> GetTransactions()
        {
            var currentUserId = _currentUser.UserId;

            if (string.IsNullOrEmpty(currentUserId))
                return Unauthorized();

            IEnumerable<Transaction> transactions = await _db.Transactions.Where(t => t.UserId == currentUserId).ToListAsync();
            return Ok(transactions);
        }

        [HttpPost("add-transaction")]
        public async Task<IActionResult> Add([FromBody] TransactionVM transaction)
        {
            if (transaction == null)
            {
                return BadRequest();
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if(!Enum.IsDefined(typeof(Category), transaction.MerchantCategory))
{
                return BadRequest("Category is Invalid");
            }

            //var currentUserId = _currentUser.UserId;

            //if (string.IsNullOrEmpty(currentUserId))
            //    return Unauthorized();

            var currentUserId = "1c1c57c6-c375-4cb8-bd9a-1d0f84055c6d"; 

            string finalRiskLevel = "Unknown";
            double finalRiskScore = 0;
            bool finalIsFraud = false;

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("ngrok-skip-browser-warning", "true");
                var mlpayload = new
                {
                    user_id = currentUserId,
                    amount = transaction.Amount,
                    hour = transaction.TransactionHour,
                    category = transaction.MerchantCategory.ToString(),
                    zip_code = transaction.ZipCode,

                };
                var response = await client.PostAsJsonAsync("https://strep-framing-punctual.ngrok-free.dev/predict", mlpayload);
                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<MLResponse>();
                    if (result != null)
                    {

                        finalRiskLevel = result.risk_level;
                        finalRiskScore = result.risk_score;
                        finalIsFraud = result.is_fraud;
                    }
                    else 
                    {
                        var errorBody = await response.Content.ReadAsStringAsync();
                        Console.WriteLine("\n================= ML API ERROR =================");
                        Console.WriteLine($"Status Code: {response.StatusCode}");
                        Console.WriteLine($"Error Details: {errorBody}");
                        Console.WriteLine("================================================\n");
                    }
                }
             }

            var newTransaction = new Transaction
            {
                Amount = transaction.Amount,
                MerchantCategory = transaction.MerchantCategory,
                ZipCode = transaction.ZipCode,
                TransactionHour = transaction.TransactionHour,
                //UserId = _currentUser.UserId,
                UserId = currentUserId,

                RiskLevel = finalRiskLevel,
                RiskScore = finalRiskScore,
                IsFraud = finalIsFraud,
            };

            await _db.Transactions.AddAsync(newTransaction);
            await _db.SaveChangesAsync();
            return Ok(newTransaction);
        }
        [AllowAnonymous]
        [HttpGet("user-stats/{userId}")]
        public async Task<IActionResult> GetUsersStats(string userId)
        {
            var stats = await _db.Transactions.Where(t => t.UserId == userId).CountAsync();
            return Ok(
                new
                {
                    transaction_count = stats
                }
                );
        } 

    }
}
