using eMovieFinder.Model.Utilities;
using System;

namespace eMovieFinder.Model.Entities
{
    public class Director : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime BirthDate { get; set; }
        public string? FormattedDirectorRealName => $"{FirstName} {LastName}";
    }
}
