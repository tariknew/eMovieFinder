using eMovieFinder.Model.Utilities;
using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Database.Entities
{
    public class Director : TimeStampObject
    {
        [Key]
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime BirthDate { get; set; }
    }
}
