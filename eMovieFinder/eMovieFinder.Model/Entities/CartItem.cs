using eMovieFinder.Model.Utilities;

namespace eMovieFinder.Model.Entities
{
    public class CartItem : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public int CartId { get; set; }
        public int MovieId { get; set; }
        public virtual Movie Movie { get; set; }
        public decimal FinalMoviePrice { get; set; }
        public string? FormattedFinalMoviePrice => FinalMoviePrice.ToString("F2");
    }
}
