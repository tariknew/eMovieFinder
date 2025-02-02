using eMovieFinder.Model.Dtos.Requests.Director;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class DirectorController : BaseCRUDController<Model.Entities.Director, Database.Entities.Director, DirectorInsertRequest, DirectorUpdateRequest, DirectorSearchObject>
    {
        public DirectorController(IDirectorService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Director> Insert([FromBody] DirectorInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Director> Update(int id, [FromBody] DirectorUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<IEnumerable<Model.Entities.Director>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}