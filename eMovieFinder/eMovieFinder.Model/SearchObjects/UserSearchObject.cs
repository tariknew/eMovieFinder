namespace eMovieFinder.Model.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public string? Username { get; set; }
        public bool? IsIdentityUserIncluded { get; set; }
    }
}
