using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.User
{
    public class UserRegistrationRequest
    {
        [RegularExpression(@"^[^!@#<>?""\:_`~;\[\]\\|=+)(*&^%-]*$", ErrorMessage = "The Username mustn't contain special characters")]
        [Required(ErrorMessage = "Username is a Required field")]
        [StringLength(10, ErrorMessage = "Username can't exceed 10 characters")]
        public string Username { get; set; }
        [Required(ErrorMessage = "Email is a Required field")]
        [EmailAddress]
        public string Email { get; set; }
        [Required(ErrorMessage = "Password is a Required field")]
        [StringLength(255, ErrorMessage = "The Password must be at least 8 characters long", MinimumLength = 8)]
        public string Password { get; set; }
        [Compare("Password", ErrorMessage = "The password and confirmation password don't match")]
        [Required(ErrorMessage = "Confirm Password is a Required field")]
        public string ConfirmPassword { get; set; }
        public string? ImagePlainText { get; set; }
        [DefaultValue(null)]
        public byte[]? Image { get; set; }
    }
}
