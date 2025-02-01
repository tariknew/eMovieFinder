namespace eMovieFinder.Model.SearchObjects
{
    public class MovieCategorySearchObject : BaseSearchObject
    {
        public string? CategoryName { get; set; }
        public int? MovieId { get; set; }
        public bool? IsMovieIncluded { get; set; }
        public bool? IsCategoryIncluded { get; set; }
    }
}
