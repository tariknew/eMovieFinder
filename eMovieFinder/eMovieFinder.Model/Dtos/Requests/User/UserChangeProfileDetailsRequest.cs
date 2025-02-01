using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.User
{
    public class UserChangeProfileDetailsRequest
    {
        public int? IdentityUserId { get; set; }
        [EmailAddress]
        public string? Email { get; set; }
        public string? CurrentPassword { get; set; }
        [StringLength(255, ErrorMessage = "The New Password must be at least 8 characters long", MinimumLength = 8)]
        public string? NewPassword { get; set; }
        public string? ImagePlainText { get; set; }
        [DefaultValue(null)]
        public byte[]? Image { get; set; }
    }
}
