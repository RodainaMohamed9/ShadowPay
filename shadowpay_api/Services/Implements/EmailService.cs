using System.Net.Mail;
using SendGrid;
using SendGrid.Helpers.Mail;
public class EmailService {
    private readonly IConfiguration _config;
    public EmailService(IConfiguration config) 
    {
        _config = config; 
    }
    public async Task SendOTP(string toEmail, string otp)
    {
        var client = new SendGridClient(_config["SendGrid:ApiKey"]);

        var from = new EmailAddress(_config["SendGrid:FromEmail"], "ShadowPay");
        var to = new EmailAddress(toEmail);

        var subject = "Your OTP Code";
        var plainTextContent = $"Your OTP is: {otp}";
        var htmlContent = $"<strong>Your OTP is: {otp}</strong>";

        var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);

        await client.SendEmailAsync(msg);
    }
}