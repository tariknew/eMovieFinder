namespace eMovieFinder.Model.SearchObjects
{
    public class MovieFavouriteSearchObject : BaseSearchObject
    {
        public string? MovieTitle { get; set; }
        public int? MovieId { get; set; }
        public int? UserId { get; set; }
        public bool? IsUserIncluded { get; set; }
        public bool? IsMovieIncluded { get; set; }
    }
}
