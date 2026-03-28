namespace shadowpay_api.ModelVM.TransactionVM
{
    public class TransactionVM
    {
        public decimal Amount { get; set; }
        public string MerchantCategory { get; set; }
        public int ZipCode { get; set; }
        public int TransactionHour { get; set; }
    }
}
