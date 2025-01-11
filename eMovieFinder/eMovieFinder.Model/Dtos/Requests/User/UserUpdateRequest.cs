using System.Collections.Generic;
using System.ComponentModel;

namespace eMovieFinder.Model.Dtos.Requests.User
{
    public class UserUpdateRequest
    {
        public string? Username { get; set; }
        public string? Email { get; set; }
        public string? Password { get; set; }
        public List<string>? Roles { get; set; }
        public string? ImagePlainText { get; set; }
        [DefaultValue(null)]
        public byte[]? Image { get; set; }
        public bool IsLockoutEnabled { get; set; }
    }
}
