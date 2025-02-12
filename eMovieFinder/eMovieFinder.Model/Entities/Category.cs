using eMovieFinder.Model.Utilities;

namespace eMovieFinder.Model.Entities
{
    public class Category : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public string CategoryName { get; set; }
    }
}
