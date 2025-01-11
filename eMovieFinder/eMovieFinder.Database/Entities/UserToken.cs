using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eMovieFinder.Database.Entities
{
    public class UserToken
    {
        [Key]
        public int Id { get; set; }
        public string ConfirmationCode { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreationDate { get; set; }
        [ForeignKey("IdentityUser")]
        public int IdentityUserId { get; set; }
        public virtual IdentityUser<int> IdentityUser { get; set; }
    }
}
