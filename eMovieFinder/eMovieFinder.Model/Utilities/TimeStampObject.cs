using Microsoft.AspNetCore.Identity;
using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace eMovieFinder.Model.Utilities
{
    public class TimeStampObject
    {
        public DateTime? CreationDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        [ForeignKey("CreatedBy")]
        public int? CreatedById { get; set; }
        public virtual IdentityUser<int> CreatedBy { get; set; }
        [ForeignKey("ModifiedBy")]
        public int? ModifiedById { get; set; }
        public virtual IdentityUser<int> ModifiedBy { get; set; }
    }
    public class TimeStampObjectViewModel
    {
        public DateTime? CreationDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public int? CreatedById { get; set; }
        public int? ModifiedById { get; set; }
        public virtual IdentityUser<int> CreatedBy { get; set; }
        public virtual IdentityUser<int> ModifiedBy { get; set; }
        public string? FormattedCreationDate => CreationDate?.ToString("MMM dd, yyyy");
        public string? FormattedModifiedDate => ModifiedDate?.ToString("MMM dd, yyyy");
    }
}
