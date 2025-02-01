using eMovieFinder.Model.Utilities;
using Microsoft.AspNetCore.Identity;
using System.Collections.Generic;
using System.Linq;

namespace eMovieFinder.Model.Entities
{
    public class User : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public byte[]? Image { get; set; }
        public bool isSoftDeleted { get; set; }
        public int IdentityUserId { get; set; }
        public string? Username { get; set; }
        public string? Email { get; set; }
        public virtual IdentityUser<int>? IdentityUser { get; set; }
        public virtual ICollection<IdentityRole<int>>? Roles { get; set; } = new List<IdentityRole<int>>();
        public string? CombinedRoles => string.Join(", ", Roles.Select(r => r.Name));
    }
}
