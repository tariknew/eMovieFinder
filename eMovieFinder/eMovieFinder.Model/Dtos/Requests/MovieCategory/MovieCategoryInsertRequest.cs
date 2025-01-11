using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.MovieCategory
{
    public class MovieCategoryInsertRequest
    {
        [Required(ErrorMessage = "MovieId is a Required field")]
        public int MovieId { get; set; }
        [Required(ErrorMessage = "CategoryId is a Required field")]
        public int CategoryId { get; set; }
    }
}
