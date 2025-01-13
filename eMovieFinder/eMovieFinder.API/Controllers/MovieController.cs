using eMovieFinder.Model.Dtos.Requests.Movie;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class MovieController : BaseCRUDController<Model.Entities.Movie, Database.Entities.Movie, MovieInsertRequest, MovieUpdateRequest, MovieSearchObject>
    {
        public MovieController(IMovieService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Movie> Insert([FromBody] MovieInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Movie> Update(int id, [FromBody] MovieUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<IEnumerable<Model.Entities.Movie>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}