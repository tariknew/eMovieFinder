using eMovieFinder.Model.Utilities;
using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eMovieFinder.Database.Entities
{
    public class User : TimeStampObject
    {
        [Key]
        public int Id { get; set; }
        public byte[]? Image { get; set; }

        [ForeignKey("IdentityUser")]
        public int IdentityUserId { get; set; }
        public virtual IdentityUser<int> IdentityUser { get; set; }
        public virtual ICollection<MovieFavourite> MovieFavourites { get; set; }
    }
}
