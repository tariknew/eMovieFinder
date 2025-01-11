using eMovieFinder.EmailService.Interfaces;
using eMovieFinder.RabbitMQService.Models.Dtos.Requests.EmailCommunication;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Text.Json;

namespace eMovieFinder.ResetPasswordConsumer.Services
{
    public class RabbitMQServiceListener : IDisposable
    {
        private readonly IConnection _connection;
        private readonly IModel _channel;
        private readonly IEmailService _emailService;
        private readonly RabbitMQService.Services.RabbitMQService _rabbitMQService;
        public RabbitMQServiceListener(RabbitMQService.Services.RabbitMQService rabbitMQService,
            IEmailService emailService, IConnectionFactory connectionFactory)
        {
            _rabbitMQService = rabbitMQService;
            _emailService = emailService;

            _connection = connectionFactory.CreateConnection();
            _channel = _connection.CreateModel();

            _rabbitMQService.DeclareQueue(_channel, "resetPasswordQueue");
        }
        public async Task SendEmail()
        {
            Console.WriteLine("Waiting for incoming messages...");

            var consumer = new EventingBasicConsumer(_channel);

            consumer.Received += async (model, ea) =>
            {
                var body = ea.Body.ToArray();
                var message = Encoding.UTF8.GetString(body);

                Console.WriteLine("A ResetPasswordRequest was successfully received from the queue");

                if (!string.IsNullOrEmpty(message) || message != null)
                {
                    var emailMessageRequest = JsonSerializer.Deserialize<EmailMessageRequest>(message);

                    try
                    {
                        await _emailService.SendEmailAsync(
                            Environment.GetEnvironmentVariable("SEND_GRID_API_KEY"),
                            emailMessageRequest.RecipientEmail,
                            emailMessageRequest.Subject,
                            emailMessageRequest.Content
                        );

                        Console.WriteLine("Password reset email successfully sent to: "
                            + emailMessageRequest.RecipientEmail);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Failed to send email. Error: " + ex.Message);
                    }
                }
            };

            _rabbitMQService.ReceiveQueue(_channel, "resetPasswordQueue", consumer);
        }
        public void Dispose()
        {
            _channel.Close();
            _connection.Close();
        }
    }
}
