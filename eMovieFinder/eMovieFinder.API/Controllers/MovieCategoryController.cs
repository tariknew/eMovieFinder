using eMovieFinder.Model.Dtos.Requests.MovieCategory;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class MovieCategoryController : BaseCRUDController<Model.Entities.MovieCategory, Database.Entities.MovieCategory, MovieCategoryInsertRequest, MovieCategoryUpdateRequest, MovieCategorySearchObject>
    {
        public MovieCategoryController(IMovieCategoryService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.MovieCategory> Insert([FromBody] MovieCategoryInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.MovieCategory> Update(int id, [FromBody] MovieCategoryUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<IEnumerable<Model.Entities.MovieCategory>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}