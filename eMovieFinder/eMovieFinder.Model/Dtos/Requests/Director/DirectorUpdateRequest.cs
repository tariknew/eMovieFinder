using System;

namespace eMovieFinder.Model.Dtos.Requests.Director
{
    public class DirectorUpdateRequest
    {
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public DateTime? BirthDate { get; set; }
    }
}
