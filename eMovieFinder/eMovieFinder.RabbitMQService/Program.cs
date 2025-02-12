using DotNetEnv;
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

        Console.WriteLine("RabbitMQ successfully started");

        Thread.Sleep(Timeout.Infinite);
    }
}