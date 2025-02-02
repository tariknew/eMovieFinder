using System.Threading.Tasks;

namespace eMovieFinder.EmailService.Interfaces
{
    public interface IEmailService
    {
        Task SendEmailAsync(string apiKey, string toEmail, string subject, string content);
    }
}
