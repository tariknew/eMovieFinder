using eMovieFinder.Database.Context;
using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.Dtos.Requests.User;
using eMovieFinder.Model.Utilities;
using eMovieFinder.RabbitMQService.Interfaces;
using eMovieFinder.RabbitMQService.Models.Dtos.Requests.EmailCommunication;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Services.Services
{
    public class UserAccountService : IUserAccountService
    {
        private readonly EMFContext _context;
        private readonly UserManager<IdentityUser<int>> _userManager;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IRabbitMQService _rabbitMQService;
        public UserAccountService(EMFContext context, UserManager<IdentityUser<int>> userManager,
            IHttpContextAccessor httpContextAccessor, IRabbitMQService rabbitMQService)
        {
            _context = context;
            _userManager = userManager;
            _httpContextAccessor = httpContextAccessor;
            _rabbitMQService = rabbitMQService;
        }
        public async Task ResetPassword(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);

            if (user == null)
                throw new UserException("No user account associated with this email");

            string newPassword = UserHelper.GenerateCode(8);

            var removePasswordResult = await _userManager.RemovePasswordAsync(user);

            if (!removePasswordResult.Succeeded)
                throw new UserException("Failed to remove the old password");

            var addPasswordResult = await _userManager.AddPasswordAsync(user, newPassword);

            if (!addPasswordResult.Succeeded)
                throw new UserException("Failed to set the new password");

            var emailMessageRequest = new EmailMessageRequest
            {
                RecipientEmail = email,
                Subject = "Reset Password",
                Content = $"Dear {user.UserName},<br><br>"
                + "You have requested to reset your password on eMovieFinder.<br>"
                + "If you did not request this, please ignore it.<br><br>"
                + "Your new password is: <strong>" + newPassword + "</strong><br><br>"
                + "For security purposes, please change your password after logging in.<br><br>"
                + "All the best,<br>eMovieFinder"
            };

            _rabbitMQService.SendResetPasswordEmailRequest(emailMessageRequest, "resetPasswordQueue");
        }
        public async Task ConfirmEmail(UserConfirmEmailRequest request)
        {
            var user = await _userManager.FindByEmailAsync(request.Email);

            if (user == null)
                throw new UserException("No user account associated with this email");

            if (user.EmailConfirmed)
                throw new UserException("This user account already has a confirmed email");

            var userToken = await _context.UserTokens
                .FirstOrDefaultAsync(ut => ut.IdentityUserId == user.Id);

            if (userToken == null)
                throw new UserException("No valid confirmation token found for this user account");

            if (userToken.ConfirmationCode != request.ConfirmationCode)
                throw new UserException("Invalid confirmation code");

            if (!userToken.IsActive)
                throw new UserException("The confirmation code isn't active");

            user.EmailConfirmed = true;
            userToken.IsActive = false;

            await _userManager.UpdateAsync(user);
            await _context.SaveChangesAsync();
        }
        public async Task<bool> ChangeUserProfileDetails(UserChangeProfileDetailsRequest request)
        {
            bool isUpdated = false;

            if (request.IdentityUserId != null && request.IdentityUserId != 0)
            {
                var currentUser = await _userManager.FindByIdAsync(request.IdentityUserId.ToString());

                if (currentUser == null)
                {
                    throw new UserException("'User' doesn't exist");
                }

                if (!string.IsNullOrEmpty(request.CurrentPassword) && !string.IsNullOrEmpty(request.NewPassword))
                {
                    var isOldPasswordCorrect = await _userManager.CheckPasswordAsync(currentUser, request.CurrentPassword);

                    if (!isOldPasswordCorrect)
                    {
                        throw new UserException("Current password is incorrect");
                    }

                    if (request.CurrentPassword == request.NewPassword)
                    {
                        throw new UserException("You already had this current password");
                    }

                    var changePassword = await _userManager.ChangePasswordAsync(currentUser, request.CurrentPassword, request.NewPassword);

                    if (changePassword.Succeeded)
                    {
                        isUpdated = true;
                    }
                    else
                    {
                        throw new UserException("Password change failed");
                    }
                }

                if (!string.IsNullOrEmpty(request.Email))
                {
                    if (currentUser.Email == request.Email)
                    {
                        throw new UserException("You already had this current email");
                    }

                    currentUser.Email = request.Email;

                    var updateResult = await _userManager.UpdateAsync(currentUser);

                    if (updateResult.Succeeded)
                    {
                        isUpdated = true;
                    }
                    else
                    {
                        throw new UserException("Email change failed");
                    }
                }

                if (!string.IsNullOrEmpty(request.ImagePlainText))
                {
                    var user = _context.Users.FirstOrDefault(u => u.IdentityUserId == request.IdentityUserId);

                    if (user == null)
                    {
                        throw new UserException("'User' doesn't exist");
                    }

                    byte[] ImageBytes = ImageHelper.ConvertImageToBytes(request.ImagePlainText);

                    user.Image = ImageBytes;

                    user.ModifiedDate = DateTime.Now;
                    user.ModifiedById = UserHelper.GetIdentityUserId(_httpContextAccessor);

                    _context.SaveChanges();

                    isUpdated = true;
                }
            }

            return isUpdated;
        }
    }
}
