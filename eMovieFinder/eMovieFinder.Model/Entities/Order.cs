using System;
using System.Collections.Generic;
using System.Linq;

namespace eMovieFinder.Model.Entities
{
    public class Order
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public virtual User User { get; set; }
        public DateTime OrderDate { get; set; }
        public virtual ICollection<OrderMovie> OrderMovies { get; set; }
        public string? FormattedOrderDate => OrderDate.ToString("yyyy MMM dd, hh:mm tt");
        public string? FinalMoviePrice => OrderMovies != null && OrderMovies.Any()
            ? string.Join(", ", OrderMovies.Select(x => x.FormattedFinalMoviePrice)) : "0.00";
    }
}
