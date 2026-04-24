namespace shadowpay_api.ModelVM.TransactionVM
{
    public class MLResponse
    {
        public string risk_level { get; set; }
        public double risk_score { get; set; }
        public bool is_fraud { get; set; }
    }
}
