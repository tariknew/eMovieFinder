namespace eMovieFinder.RabbitMQService.Models.Dtos.Requests.EmailCommunication
{
    public class EmailMessageRequest
    {
        public string RecipientEmail { get; set; }
        public string Subject { get; set; }
        public string Content { get; set; }
    }
}
