using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.User
{
    public class UserConfirmEmailRequest
    {
        [Required(ErrorMessage = "Email is a Required field")]
        [EmailAddress]
        public string Email { get; set; }
        [Required(ErrorMessage = "ConfirmationCode is a Required field")]
        public string ConfirmationCode { get; set; }
    }
}
