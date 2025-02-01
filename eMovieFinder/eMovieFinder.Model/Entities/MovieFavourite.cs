using eMovieFinder.Model.Utilities;

namespace eMovieFinder.Model.Entities
{
    public class MovieFavourite : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int MovieId { get; set; }
        public virtual Movie Movie { get; set; }
        public virtual User User { get; set; }
    }
}
