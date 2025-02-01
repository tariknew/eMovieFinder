using eMovieFinder.Model.Utilities;
using System;

namespace eMovieFinder.Model.Entities
{
    public class Actor : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public byte[]? Image { get; set; }
        public DateTime BirthDate { get; set; }
        public int? CountryId { get; set; }
        public string IMDbLink { get; set; }
        public string Biography { get; set; }
        public string? FormattedActorBirthDate => BirthDate.ToString("yyyy-MM-dd");
        public string? FormattedActorBirthPlace => Country?.CountryName;
        public string? FormattedActorRealName => $"{FirstName} {LastName}";
        public virtual Country Country { get; set; }
    }
}
