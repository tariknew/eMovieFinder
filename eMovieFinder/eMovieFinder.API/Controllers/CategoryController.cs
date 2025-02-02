using eMovieFinder.Model.Dtos.Requests.Category;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class CategoryController : BaseCRUDController<Model.Entities.Category, Database.Entities.Category, CategoryInsertRequest, CategoryUpdateRequest, CategorySearchObject>
    {
        public CategoryController(ICategoryService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Category> Insert([FromBody] CategoryInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Category> Update(int id, [FromBody] CategoryUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<IEnumerable<Model.Entities.Category>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}