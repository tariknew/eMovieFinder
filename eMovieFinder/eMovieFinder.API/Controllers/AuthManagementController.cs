using eMovieFinder.Model.Dtos.Requests.User;
using eMovieFinder.Model.Dtos.Responses.Auth;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    public class AuthManagementController : ControllerBase
    {
        private readonly IAuthManagementService _service;
        public AuthManagementController(IAuthManagementService service)
        {
            _service = service;
        }
        [HttpPost]
        public async Task Register([FromBody] UserRegistrationRequest request)
        {
            await _service.Register(request);
        }
        [HttpPost]
        public async Task<LoginResponse> Login([FromQuery] UserLoginRequest request)
        {
            return await _service.Login(request);
        }
    }
}