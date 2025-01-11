using eMovieFinder.Model.Dtos.Requests.User;
using eMovieFinder.Model.Dtos.Responses.Auth;

namespace eMovieFinder.Services.Interfaces
{
    public interface IAuthManagementService
    {
        Task Register(UserRegistrationRequest request);
        Task<LoginResponse> Login(UserLoginRequest request);
    }
}
