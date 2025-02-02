using System.Collections.Generic;

namespace eMovieFinder.Model.Dtos.Responses.Auth
{
    public class LoginResponse
    {
        public string Token { get; set; }
        public bool IsSuccess { get; set; }
        public int UserId { get; set; }
        public IList<string> Roles { get; set; }
    }
}