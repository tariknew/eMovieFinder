using eMovieFinder.Model.Dtos.Requests.Actor;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class ActorController : BaseCRUDController<Model.Entities.Actor, Database.Entities.Actor, ActorInsertRequest, ActorUpdateRequest, ActorSearchObject>
    {
        public ActorController(IActorService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Actor> Insert([FromBody] ActorInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Actor> Update(int id, [FromBody] ActorUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<IEnumerable<Model.Entities.Actor>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}