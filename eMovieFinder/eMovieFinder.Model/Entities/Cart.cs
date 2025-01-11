using eMovieFinder.Model.Utilities;
using System.Collections.Generic;

namespace eMovieFinder.Model.Entities
{
    public class Cart : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public virtual User User { get; set; }
        public decimal CartTotalPrice { get; set; }
        public virtual ICollection<CartItem> CartItems { get; set; }
        public string? FormattedCartTotalPrice => CartTotalPrice.ToString("F2");
    }
}
