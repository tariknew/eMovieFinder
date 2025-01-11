using eMovieFinder.Model.Utilities;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eMovieFinder.Database.Entities
{
    public class Cart : TimeStampObject
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey("User")]
        public int UserId { get; set; }
        public virtual User User { get; set; }
        public decimal CartTotalPrice { get; set; }
        public virtual ICollection<CartItem> CartItems { get; set; }
    }
}
