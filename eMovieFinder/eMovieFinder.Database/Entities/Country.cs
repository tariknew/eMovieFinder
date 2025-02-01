using eMovieFinder.Model.Utilities;
using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Database.Entities
{
    public class Country : TimeStampObject
    {
        [Key]
        public int Id { get; set; }
        public string CountryName { get; set; }
    }
}
