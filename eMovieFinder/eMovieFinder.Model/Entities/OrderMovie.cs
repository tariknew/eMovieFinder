using System;

namespace eMovieFinder.Model.Entities
{
    public class OrderMovie
    {
        public int Id { get; set; }
        public int OrderId { get; set; }
        public int MovieId { get; set; }
        public virtual Movie Movie { get; set; }
        public decimal FinalMoviePrice => CalculateFinalMoviePrice(Movie.Price, Movie.Discount);
        public string? FormattedFinalMoviePrice => FinalMoviePrice.ToString("F2");
        public string? FormattedMovieTitle => Movie.Title;
        /* Calculate Final Movie Price */
        public decimal CalculateFinalMoviePrice(double moviePrice, decimal? movieDiscount)
        {
            decimal moviePriceDecimal = Convert.ToDecimal(moviePrice);
            decimal discount = movieDiscount ?? 0;

            return (moviePriceDecimal - (moviePriceDecimal * (discount / 100)));
        }
    }
}
