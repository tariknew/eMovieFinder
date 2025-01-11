using System;
using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.Director
{
    public class DirectorInsertRequest
    {
        [Required(ErrorMessage = "FirstName is a Required field")]
        public string FirstName { get; set; }
        [Required(ErrorMessage = "LastName is a Required field")]
        public string LastName { get; set; }
        [Required(ErrorMessage = "BirthDate is a Required field")]
        public DateTime BirthDate { get; set; }
    }
}
