using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.Country
{
    public class CountryInsertRequest
    {
        [Required(ErrorMessage = "CountryName is a Required field")]
        public string CountryName { get; set; }
    }
}
