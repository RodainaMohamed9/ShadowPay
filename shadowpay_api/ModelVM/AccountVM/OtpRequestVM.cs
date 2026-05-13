namespace shadowpay_api.ModelVM.AccountVM
{
    public class OtpRequestVM
    {
        public string Email { get; set; } = null!;
        public string Purpose { get; set; } = null!; // "register" أو "forgot"

        // فقط للـ Register
        public string? FullName { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Password { get; set; }
        public string? CardNumberHash { get; set; }
        public string? CardHolderName { get; set; }
        public DateTime? ExprDate { get; set; }
        public decimal? Balance { get; set; }
        public string CardType { get; set; }
    }

    public class OtpVerifyVM
    {
        public string Email { get; set; } = null!;
        public string OTP { get; set; } = null!;
        public string Purpose { get; set; } = null!;
    }
}
