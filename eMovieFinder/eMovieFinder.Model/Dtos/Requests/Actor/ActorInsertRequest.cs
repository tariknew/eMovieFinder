using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.Actor
{
    public class ActorInsertRequest
    {
        [Required(ErrorMessage = "FirstName is a Required field")]
        public string FirstName { get; set; }
        [Required(ErrorMessage = "LastName is a Required field")]
        public string LastName { get; set; }
        [Required(ErrorMessage = "ImagePlainText is a Required field")]
        public string? ImagePlainText { get; set; }
        [DefaultValue(null)]
        public byte[]? Image { get; set; }
        [Required(ErrorMessage = "BirthDate is a Required field")]
        public DateTime BirthDate { get; set; }
        [Required(ErrorMessage = "CountryId is a Required field")]
        public int CountryId { get; set; }
        [Required(ErrorMessage = "IMDbLink is a Required field")]
        public string IMDbLink { get; set; }
        [Required(ErrorMessage = "Biography is a Required field")]
        public string Biography { get; set; }
    }
}
