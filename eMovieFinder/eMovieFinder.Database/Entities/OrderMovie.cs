using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eMovieFinder.Database.Entities
{
    public class OrderMovie
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey("Order")]
        public int OrderId { get; set; }
        public virtual Order Order { get; set; }
        [ForeignKey("Movie")]
        public int MovieId { get; set; }
        public virtual Movie Movie { get; set; }
    }
}
