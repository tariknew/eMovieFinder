using eMovieFinder.Model.Dtos.Requests.MovieFavourite;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class MovieFavouriteController : BaseCRUDController<Model.Entities.MovieFavourite, Database.Entities.MovieFavourite, MovieFavouriteInsertRequest, MovieFavouriteUpdateRequest, MovieFavouriteSearchObject>
    {
        public MovieFavouriteController(IMovieFavouriteService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public override async Task<Model.Entities.MovieFavourite> Insert([FromBody] MovieFavouriteInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.MovieFavourite> Update(int id, [FromBody] MovieFavouriteUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public override async Task<IEnumerable<Model.Entities.MovieFavourite>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}