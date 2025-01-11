using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.MovieReview
{
    public class MovieReviewUpdateRequest
    {
        [Range(1, 5, ErrorMessage = "Rating must be between 1 and 5")]
        public double? Rating { get; set; }
        public string? Comment { get; set; }
        public int? UserId { get; set; }
        public int? MovieId { get; set; }
    }
}
