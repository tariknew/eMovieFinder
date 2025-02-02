using eMovieFinder.RabbitMQService.Interfaces;
using eMovieFinder.RabbitMQService.Models.Dtos.Requests.EmailCommunication;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Text.Json;

namespace eMovieFinder.RabbitMQService.Services
{
    public class RabbitMQService : IRabbitMQService
    {
        private readonly IConnection _connection;
        public RabbitMQService(IConnectionFactory connectionFactory)
        {
            _connection = connectionFactory.CreateConnection();
        }
        public void SendResetPasswordEmailRequest(EmailMessageRequest emailRequest, string queueName)
        {
            using var channel = _connection.CreateModel();

            DeclareQueue(channel, queueName);

            var message = JsonSerializer.Serialize(emailRequest);

            PublishQueue(channel, queueName, message);
        }
        public void DeclareQueue(IModel channel, string queueName)
        {
            channel.QueueDeclare
            (
                queue: queueName,
                durable: false,
                exclusive: false,
                autoDelete: false,
                arguments: null
            );
        }
        public void PublishQueue(IModel channel, string routingKey, string message)
        {
            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish
            (
                exchange: "",
                routingKey: routingKey,
                basicProperties: null,
                body: body
            );
        }
        public void ReceiveQueue(IModel channel, string queueName, EventingBasicConsumer consumer)
        {
            channel.BasicConsume
            (
                queue: queueName,
                autoAck: true,
                consumer: consumer
            );
        }
        public void Dispose()
        {
            _connection.Close();
        }
    }
}
