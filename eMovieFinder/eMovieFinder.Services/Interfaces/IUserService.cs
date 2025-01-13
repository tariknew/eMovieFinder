using eMovieFinder.Model.Dtos.Requests.User;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface IUserService : ICRUDService<User, UserInsertRequest, UserUpdateRequest, UserSearchObject> { }
}