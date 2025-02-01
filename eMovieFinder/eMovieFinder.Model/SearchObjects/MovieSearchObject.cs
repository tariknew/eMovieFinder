namespace eMovieFinder.Model.SearchObjects
{
    public class MovieSearchObject : BaseSearchObject
    {
        public string? Title { get; set; }
        public int? CategoryId { get; set; }
        public double? PriceGTE { get; set; }
        public double? PriceLTE { get; set; }
        public bool? IsDirectorIncluded { get; set; }
        public bool? IsCountryIncluded { get; set; }
        public bool? IsMovieReviewsIncluded { get; set; }
        public bool? IsMovieCategoriesIncluded { get; set; }
        public bool? IsMovieActorsIncluded { get; set; }
        public bool? IsAdministratorPanel { get; set; }
    }
}
