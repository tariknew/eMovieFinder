using eMovieFinder.Model.Dtos.Requests.User;

namespace eMovieFinder.Services.Interfaces
{
    public interface IUserAccountService
    {
        Task ResetPassword(string email);
        Task ConfirmEmail(UserConfirmEmailRequest request);
        Task<bool> ChangeUserProfileDetails(UserChangeProfileDetailsRequest request);
    }
}
