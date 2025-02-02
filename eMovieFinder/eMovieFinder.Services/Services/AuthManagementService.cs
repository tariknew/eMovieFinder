using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.EmailService.Interfaces;
using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.Dtos.Requests.User;
using eMovieFinder.Model.Dtos.Responses.Auth;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace eMovieFinder.Services.Services
{
    public class AuthManagementService : IAuthManagementService
    {
        private readonly UserManager<IdentityUser<int>> _userManager;
        private readonly JwtConfig _jwtConfig;
        private readonly EMFContext _context;
        private readonly IEmailService _emailService;
        public AuthManagementService(UserManager<IdentityUser<int>> userManager,
            IOptionsMonitor<JwtConfig> optionsMonitor, EMFContext context,
            IEmailService emailService)
        {
            _userManager = userManager;
            _jwtConfig = optionsMonitor.CurrentValue;
            _context = context;
            _emailService = emailService;
        }
        public async Task<LoginResponse> Login(UserLoginRequest request)
        {
            var existingUser = await _userManager.FindByNameAsync(request.Username);

            if (existingUser == null)
                throw new UserException("Incorrect username or password");

            var isUserSoftDeleted = await _context.Users.FirstOrDefaultAsync(x => x.IdentityUserId == existingUser.Id);

            if (isUserSoftDeleted != null && isUserSoftDeleted.isSoftDeleted)
                throw new UserException("This user account is deactivated");

            if (existingUser.LockoutEnd != null)
                throw new UserException("Your user account is permanently banned");

            var isCorrect = await _userManager.CheckPasswordAsync(existingUser, request.Password);

            if (!isCorrect)
                throw new UserException("Incorrect username or password");

            if (!existingUser.EmailConfirmed)
                throw new UserException("Email address isn't confirmed");

            IList<string> roles = await _userManager.GetRolesAsync(existingUser);

            var jwtToken = GenerateJwtToken(existingUser, roles);
            int? userId = _context.Users.Where(x => x.IdentityUserId == existingUser.Id).FirstOrDefault()?.Id;

            return new LoginResponse
            {
                IsSuccess = true,
                Token = jwtToken,
                UserId = (int)(userId != null ? userId : 0),
                Roles = roles
            };
        }
        public async Task Register(UserRegistrationRequest request)
        {
            var existingUserEmail = await _userManager.FindByEmailAsync(request.Email);

            var existingUserUsername = await _userManager.FindByNameAsync(request.Username);

            if (existingUserEmail != null)
                throw new UserException("E-mail address already in use");

            if (existingUserUsername != null)
                throw new UserException("Username already in use");

            if (request.Password != request.ConfirmPassword)
                throw new UserException("Password and confirmation password don't match");

            var newIdentityUser = new IdentityUser<int> { Email = request.Email, UserName = request.Username };
            var isCreated = await _userManager.CreateAsync(newIdentityUser, request.Password);

            if (!isCreated.Succeeded)
            {
                throw new UserException("Something went wrong, unable to create the account");
            }
            else
            {
                await _userManager.AddToRoleAsync(newIdentityUser, "User");

                byte[] ImageBytes = null;

                if (!string.IsNullOrEmpty(request.ImagePlainText))
                {
                    ImageBytes = ImageHelper.ConvertImageToBytes(request.ImagePlainText);
                }

                var newUser = new User
                {
                    IdentityUserId = newIdentityUser.Id,
                    Image = ImageBytes,
                    CreationDate = DateTime.Now
                };

                _context.Users.Add(newUser);
                await _context.SaveChangesAsync();

                string confirmationCode = UserHelper.GenerateCode(8);

                var userToken = new UserToken
                {
                    ConfirmationCode = confirmationCode,
                    IsActive = true,
                    CreationDate = DateTime.Now,
                    IdentityUserId = newIdentityUser.Id
                };

                _context.UserTokens.Add(userToken);
                await _context.SaveChangesAsync();

                await _emailService.SendEmailAsync(Environment.GetEnvironmentVariable("SEND_GRID_API_KEY"),
                    request.Email, "Confirm Email", $"Dear {request.Username},<br><br>"
                + "Thank you for registering!<br>"
                + "To complete your registration, please confirm your email.<br><br>"
                + "Your confirmation code is: <strong>" + confirmationCode + "</strong><br><br>"
                + "All the best,<br>eMovieFinder");
            }
        }
        private string GenerateJwtToken(IdentityUser<int> user, IList<string> roles)
        {
            var jwtTokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_jwtConfig.SecretKey);

            List<Claim> claims = new List<Claim>
            {
                new Claim("Id", user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(JwtRegisteredClaimNames.Sub, user.UserName),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };
            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddHours(6),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
            };

            var token = jwtTokenHandler.CreateToken(tokenDescriptor);
            var jwtToken = jwtTokenHandler.WriteToken(token);

            return jwtToken;
        }
    }
}