using eMovieFinder.Model.Utilities;
using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Database.Entities
{
    public class Category : TimeStampObject
    {
        [Key]
        public int Id { get; set; }
        public string CategoryName { get; set; }
    }
}
