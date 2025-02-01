using eMovieFinder.Model.Dtos.Requests.User;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    public class UserAccountController : ControllerBase
    {
        private readonly IUserAccountService _service;
        public UserAccountController(IUserAccountService service)
        {
            _service = service;
        }
        [HttpPost]
        public async Task ResetPassword([FromQuery] string email)
        {
            await _service.ResetPassword(email);
        }
        [HttpPost]
        public async Task ConfirmEmail([FromQuery] UserConfirmEmailRequest request)
        {
            await _service.ConfirmEmail(request);
        }
        [HttpPut]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public async Task<bool> ChangeUserProfileDetails([FromBody] UserChangeProfileDetailsRequest request)
        {
            var result = await _service.ChangeUserProfileDetails(request);

            return result;
        }
    }
}