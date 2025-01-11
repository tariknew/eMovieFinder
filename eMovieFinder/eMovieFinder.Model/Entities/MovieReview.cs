using eMovieFinder.Model.Utilities;

namespace eMovieFinder.Model.Entities
{
    public class MovieReview : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public double Rating { get; set; }
        public string Comment { get; set; }
        public int UserId { get; set; }
        public int MovieId { get; set; }
        public string? FormattedAverageRating { get; set; }
        public virtual User User { get; set; }
    }
}
