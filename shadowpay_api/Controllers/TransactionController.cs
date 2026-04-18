
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using shadowpay_api.Data;
using shadowpay_api.Models;
using shadowpay_api.ModelVM.TransactionVM;
using shadowpay_api.Services;


namespace shadowpay_api.Controllers
{
    [Authorize]
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

            var currentUserId = _currentUser.UserId;

            if (string.IsNullOrEmpty(currentUserId))
                return Unauthorized();

            var newTransaction = new Transaction
            {
                Amount = transaction.Amount,
                MerchantCategory = transaction.MerchantCategory,
                ZipCode = transaction.ZipCode,
                TransactionHour = transaction.TransactionHour,
                UserId = _currentUser.UserId
            };

            await _db.Transactions.AddAsync(newTransaction);
            await _db.SaveChangesAsync();
            return CreatedAtAction(nameof(GetTransactions), new { id = newTransaction.Id }, newTransaction);
        }

    }
}
