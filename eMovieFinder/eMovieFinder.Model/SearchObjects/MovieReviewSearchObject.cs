namespace eMovieFinder.Model.SearchObjects
{
    public class MovieReviewSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? MovieId { get; set; }
        public bool? IsUserIncluded { get; set; }
        public bool? IsMovieIncluded { get; set; }
    }
}
