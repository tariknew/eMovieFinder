using eMovieFinder.EmailService.Interfaces;
using SendGrid;
using SendGrid.Helpers.Mail;
using System.Threading.Tasks;

namespace eMovieFinder.EmailService.Services
{
    public class EmailService : IEmailService
    {
        public async Task SendEmailAsync(string apiKey, string toEmail, string subject, string content)
        {
            var client = new SendGridClient(apiKey);
            var from = new EmailAddress("tarik.smajlovic@edu.fit.ba", "eMovieFinder");
            var to = new EmailAddress(toEmail);
            var msg = MailHelper.CreateSingleEmail(from, to, subject, content, content);
            var response = await client.SendEmailAsync(msg);
        }
    }
}
