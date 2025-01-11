using DotNetEnv;
using eMovieFinder.EmailService.Services;
using eMovieFinder.RabbitMQService.Services;
using eMovieFinder.ResetPasswordConsumer.Services;
using RabbitMQ.Client;
class Program
{
    static async Task Main(string[] args)
    {
        Env.Load(@"../../../../.env");

        //RabbitMQ connection
        var hostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST");
        var userName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME");
        var password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD");

        var connectionFactory = new ConnectionFactory()
        {
            HostName = hostName,
            UserName = userName,
            Password = password,
            RequestedHeartbeat = TimeSpan.FromSeconds(60),
            AutomaticRecoveryEnabled = true
        };

        var rabbitMQService = new RabbitMQService(connectionFactory);

        var emailService = new EmailService();

        var rabbitMQListener = new RabbitMQServiceListener(
            rabbitMQService,
            emailService,
            connectionFactory
        );

        await rabbitMQListener.SendEmail();

        Thread.Sleep(Timeout.Infinite);
    }
}