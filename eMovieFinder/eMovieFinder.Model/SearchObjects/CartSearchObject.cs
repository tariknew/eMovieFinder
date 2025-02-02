namespace eMovieFinder.Model.SearchObjects
{
    public class CartSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? MovieId { get; set; }
        public string? Username { get; set; }
        public string? MovieTitle { get; set; }
        public bool? IsUserIncluded { get; set; }
        public bool? IsCartItemIncluded { get; set; }
    }
}
