using System;
using System.ComponentModel;

namespace eMovieFinder.Model.Dtos.Requests.Actor
{
    public class ActorUpdateRequest
    {
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? ImagePlainText { get; set; }
        [DefaultValue(null)]
        public byte[]? Image { get; set; }
        public DateTime? BirthDate { get; set; }
        public int? CountryId { get; set; }
        public string? IMDbLink { get; set; }
        public string? Biography { get; set; }
    }
}
