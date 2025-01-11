namespace eMovieFinder.Model.SearchObjects
{
    public class OrderSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public bool? IsUserIncluded { get; set; }
        public bool? IsOrderMovieIncluded { get; set; }
    }
}
