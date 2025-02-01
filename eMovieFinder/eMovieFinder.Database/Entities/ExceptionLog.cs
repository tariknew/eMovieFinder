using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Database.Entities
{
    public class ExceptionLog
    {
        [Key]
        public int Id { get; set; }
        public string Message { get; set; }
        public int? StatusCode { get; set; }
        public string? StackTrace { get; set; }
        public DateTime CreationDate { get; set; }
    }
}
