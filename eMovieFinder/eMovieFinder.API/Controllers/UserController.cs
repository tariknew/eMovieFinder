using eMovieFinder.Model.Dtos.Requests.User;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class UserController : BaseCRUDController<Model.Entities.User, Database.Entities.User, UserInsertRequest, UserUpdateRequest, UserSearchObject>
    {
        public UserController(IUserService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.User> Insert([FromBody] UserInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.User> Update(int id, [FromBody] UserUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<IEnumerable<Model.Entities.User>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}