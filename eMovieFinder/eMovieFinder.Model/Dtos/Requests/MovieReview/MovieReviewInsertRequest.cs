using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.MovieReview
{
    public class MovieReviewInsertRequest
    {
        [Required(ErrorMessage = "Rating is a Required field")]
        [Range(1, 5, ErrorMessage = "Rating must be between 1 and 5")]
        public double Rating { get; set; }
        [Required(ErrorMessage = "Comment is a Required field")]
        [StringLength(15, ErrorMessage = "Comment can't exceed 15 characters")]
        public string Comment { get; set; }
        [Required(ErrorMessage = " UserId is a Required field")]
        public int UserId { get; set; }
        [Required(ErrorMessage = "MovieId is a Required field")]
        public int MovieId { get; set; }
    }
}
