using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.Utilities;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace eMovieFinder.Model.Entities
{
    public class Movie : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public DateTime ReleaseDate { get; set; }
        public int Duration { get; set; }
        public int? DirectorId { get; set; }
        public int? CountryId { get; set; }
        public string TrailerLink { get; set; }
        public byte[]? Image { get; set; }
        public string StoryLine { get; set; }
        public double Price { get; set; }
        public decimal? Discount { get; set; }
        public double? AverageRating { get; set; }
        public MovieStatesEnumeration.MovieStatesEnum? MovieState { get; set; }
        public string? FormattedMovieState => MovieState.ToString();
        public decimal FinalMoviePrice => CalculateFinalMoviePrice(Price, Discount);
        public string? FormattedFinalMoviePrice => FinalMoviePrice.ToString("F2");
        public double DoubleFinalMoviePrice => Convert.ToDouble(FinalMoviePrice);
        public string FormattedAverageRating => AverageRating.HasValue
            ? (AverageRating.Value % 1 == 0
            ? AverageRating.Value.ToString("0.0")
            : AverageRating.Value.ToString("0.00"))
            : "0.0";
        public string? FormattedPrice => FormatPrice(Price);
        public string? FormattedDiscount => Discount.HasValue && Discount.Value > 0 ? $"{Discount.Value.ToString("0")}%" : "No Discount";
        public string? FormattedReleaseDate => ReleaseDate.ToString("MMM dd, yyyy");
        public string? FormattedDuration => CalculateHoursAndMinutes(Duration);
        public string? CategoriesNames => MovieCategories != null
            ? string.Join(", ", MovieCategories?.Select(x => x?.Category?.CategoryName).ToList().Distinct()) : null;
        public string? ActorsNames => MovieActors != null
            ? string.Join(", ", MovieActors?.Select(x => x?.Actor?.FormattedActorRealName).ToList().Distinct()) : null;
        public string? DirectorName => $"{Director?.FirstName} {Director?.LastName}";
        public virtual Director Director { get; set; }
        public virtual Country Country { get; set; }
        public virtual ICollection<MovieCategory> MovieCategories { get; set; }
        public virtual ICollection<MovieReview> MovieReviews { get; set; }
        public virtual ICollection<MovieActor> MovieActors { get; set; }

        /* Price Format */
        private static string FormatPrice(double value)
        {
            var frenchCulture = new CultureInfo("fr-FR");
            frenchCulture.NumberFormat.CurrencyPositivePattern = 0;
            frenchCulture.NumberFormat.CurrencyNegativePattern = 2;
            frenchCulture.NumberFormat.CurrencyDecimalSeparator = ".";

            return value.ToString("C", frenchCulture);
        }
        /* Duration Format */
        private static string CalculateHoursAndMinutes(int duration)
        {
            int hours = duration / 60;
            int minutes = duration % 60;

            return $"{hours}h {minutes}m";
        }
        /* Calculate Final Movie Price */
        public decimal CalculateFinalMoviePrice(double moviePrice, decimal? movieDiscount)
        {
            decimal moviePriceDecimal = Convert.ToDecimal(moviePrice);
            decimal discount = movieDiscount ?? 0;

            return (moviePriceDecimal - (moviePriceDecimal * (discount / 100)));
        }
    }
}
