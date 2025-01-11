using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.MovieFavourite
{
    public class MovieFavouriteInsertRequest
    {
        [Required(ErrorMessage = "UserId is a Required field")]
        public int UserId { get; set; }
        [Required(ErrorMessage = "MovieId is a Required field")]
        public int MovieId { get; set; }
    }
}
