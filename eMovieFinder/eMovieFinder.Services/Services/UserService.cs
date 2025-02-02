using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.Dtos.Requests.User;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Services.Services
{
    public class UserService : BaseCRUDService<Model.Entities.User, User, UserInsertRequest, UserUpdateRequest, UserSearchObject>
    , IUserService
    {
        private readonly UserManager<IdentityUser<int>> _userManager;
        public UserService(EMFContext context, IMapper mapper,
            IHttpContextAccessor httpContextAccessor, UserManager<IdentityUser<int>> userManager)
            : base(context, mapper, httpContextAccessor)
        {
            _userManager = userManager;
        }
        public override IQueryable<User> AddFilter(UserSearchObject search, IQueryable<User> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.Username))
            {
                query = query.Where(x => x.IdentityUser.UserName.Contains(search.Username));
            }

            query = query.Where(x => x.isSoftDeleted == false);

            query = ApplyInclude(search, query);

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "LastAddedUsers":
                        query = SortBy(query, m => m.CreationDate,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override async Task<List<Model.Entities.User>> FillTheModel(List<Model.Entities.User> model)
        {
            foreach (var viewModel in model)
            {
                var user = await _userManager.FindByIdAsync(viewModel.IdentityUserId.ToString());

                if (user != null)
                {
                    var roles = await _userManager.GetRolesAsync(user);

                    viewModel.Roles = roles.Select(role => new IdentityRole<int> { Name = role }).ToList();
                }
            }

            return model;
        }
        public override async Task BeforeInsert(UserInsertRequest request, User entity)
        {
            var existingUser = await _userManager.FindByNameAsync(request.Username);

            if (existingUser != null)
            {
                throw new UserException($"A user with the username '{request.Username}' already exists.");
            }

            if (!string.IsNullOrEmpty(request.ImagePlainText))
            {
                byte[] ImageBytes = ImageHelper.ConvertImageToBytes(request.ImagePlainText);

                entity.Image = ImageBytes;
            }

            var newIdentityUser = new IdentityUser<int>
            {
                UserName = request.Username,
                Email = request.Email
            };

            await _userManager.CreateAsync(newIdentityUser, request.Password);

            if (request.Roles != null && request.Roles.Any())
            {
                foreach (var role in request.Roles)
                {
                    await _userManager.AddToRoleAsync(newIdentityUser, role);
                }
            }

            entity.IdentityUserId = newIdentityUser.Id;
            newIdentityUser.EmailConfirmed = true;
        }
        public override async Task BeforeUpdateAsync(UserUpdateRequest request, User entity)
        {
            if (entity == null)
            {
                throw new UserException($"'User' doesn't exist");
            }

            var existingUser = await _userManager.FindByNameAsync(request.Username);

            if (existingUser != null)
            {
                throw new UserException($"A user with the username '{request.Username}' already exists.");
            }

            if (!string.IsNullOrEmpty(request.ImagePlainText))
            {
                byte[] ImageBytes = ImageHelper.ConvertImageToBytes(request.ImagePlainText);

                entity.Image = ImageBytes;
            }

            var identityUser = await _userManager.FindByIdAsync(entity.IdentityUserId.ToString());

            if (identityUser == null)
            {
                throw new UserException($"'User' doesn't exist");
            }

            if (!string.IsNullOrEmpty(request.Username))
            {
                identityUser.UserName = request.Username;

                await _userManager.UpdateAsync(identityUser);
            }

            if (!string.IsNullOrEmpty(request.Email))
            {
                identityUser.Email = request.Email;

                await _userManager.UpdateAsync(identityUser);
            }

            if (!string.IsNullOrEmpty(request.Password))
            {
                await _userManager.RemovePasswordAsync(identityUser);
                await _userManager.AddPasswordAsync(identityUser, request.Password);
            }

            if (request.Roles != null && request.Roles.Any())
            {
                var currentRoles = await _userManager.GetRolesAsync(identityUser);

                await _userManager.RemoveFromRolesAsync(identityUser, currentRoles);

                foreach (var role in request.Roles)
                {
                    await _userManager.AddToRoleAsync(identityUser, role);
                }
            }

            if (request.IsLockoutEnabled == true)
            {
                identityUser.LockoutEnabled = true;
                identityUser.LockoutEnd = DateTimeOffset.MaxValue;
            }
            else
            {
                identityUser.LockoutEnabled = false;
                identityUser.LockoutEnd = null;
            }
        }
        public override async Task<IEnumerable<Model.Entities.User>> Delete(int id)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
                throw new UserException($"'User' doesn't exist");

            if (user.isSoftDeleted)
                throw new UserException($"'User' is already soft deleted");

            user.isSoftDeleted = true;

            await _context.SaveChangesAsync();

            return Enumerable.Empty<Model.Entities.User>();
        }
        public override async Task<Model.Entities.User> GetById(int id, UserSearchObject search)
        {
            var userQuery = _context.Users.AsQueryable();

            userQuery = ApplyInclude(search, userQuery);

            var user = userQuery.FirstOrDefault(x => x.Id == id);

            if (user == null)
            {
                throw new UserException($"'User' doesn't exist");
            }

            return _mapper.Map<Model.Entities.User>(user);
        }
        private IQueryable<User> ApplyInclude(UserSearchObject search, IQueryable<User> query)
        {
            if (search.IsIdentityUserIncluded == true)
            {
                query = query.Include(x => x.IdentityUser);
            }

            return query;
        }
    }
}