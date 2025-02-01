using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.User
{
    public class UserLoginRequest
    {
        [Required(ErrorMessage = "Username is a Required field")]
        public string Username { get; set; }
        [Required(ErrorMessage = "Password is a Required field")]
        public string Password { get; set; }
    }
}
