using eMovieFinder.Model.Utilities;

namespace eMovieFinder.Model.Entities
{
    public class MovieCategory : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public int MovieId { get; set; }
        public int CategoryId { get; set; }
        public virtual Category Category { get; set; }
    }
}
