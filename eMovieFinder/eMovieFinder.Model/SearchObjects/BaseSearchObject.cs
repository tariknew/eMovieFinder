namespace eMovieFinder.Model.SearchObjects
{
    public class BaseSearchObject
    {
        public int? PageNumber { get; set; }
        public int? PageSize { get; set; }
        public string? OrderBy { get; set; }
        public bool? IsDescending { get; set; }
    }
}