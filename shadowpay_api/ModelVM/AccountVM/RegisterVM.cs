namespace shadowpay_api.ModelVM.AccountVM
{
    public class RegisterVM
    {
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string PhoneNumber { get; set; }
        public string CardNumberHash { get; set; }
        public string CardHolderName { get; set; }
        public DateTime ExprDate { get; set; }
    }
}
