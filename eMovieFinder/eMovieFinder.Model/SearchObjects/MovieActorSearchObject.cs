namespace eMovieFinder.Model.SearchObjects
{
    public class MovieActorSearchObject : BaseSearchObject
    {
        public string? FullName { get; set; }
        public int? MovieId { get; set; }
        public bool? IsMovieIncluded { get; set; }
        public bool? IsActorIncluded { get; set; }
    }
}
