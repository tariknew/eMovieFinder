using eMovieFinder.Model.Dtos.Requests.MovieActor;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class MovieActorController : BaseCRUDController<Model.Entities.MovieActor, Database.Entities.MovieActor, MovieActorInsertRequest, MovieActorUpdateRequest, MovieActorSearchObject>
    {
        public MovieActorController(IMovieActorService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.MovieActor> Insert([FromBody] MovieActorInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.MovieActor> Update(int id, [FromBody] MovieActorUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<IEnumerable<Model.Entities.MovieActor>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}