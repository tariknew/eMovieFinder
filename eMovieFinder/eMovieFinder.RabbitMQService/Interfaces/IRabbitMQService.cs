using eMovieFinder.RabbitMQService.Models.Dtos.Requests.EmailCommunication;

namespace eMovieFinder.RabbitMQService.Interfaces
{
    public interface IRabbitMQService : IDisposable
    {
        void SendResetPasswordEmailRequest(EmailMessageRequest emailRequest, string queueName);
    }
}
