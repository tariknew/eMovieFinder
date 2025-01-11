using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class BaseCRUDController<TModel, TDbEntity, TInsert, TUpdate, TSearch> : BaseReadController<TModel, TSearch>
        where TModel : class where TDbEntity : class where TInsert : class where TUpdate : class where TSearch : BaseSearchObject
    {
        protected new ICRUDService<TModel, TInsert, TUpdate, TSearch> _crudService;
        public BaseCRUDController(ICRUDService<TModel, TInsert, TUpdate, TSearch> service) : base(service)
        {
            _crudService = service;
        }
        [HttpPost]
        public virtual async Task<TModel> Insert([FromBody] TInsert request)
        {
            var result = await _crudService.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        public virtual async Task<TModel> Update(int id, [FromBody] TUpdate request)
        {
            var result = await _crudService.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        public virtual async Task<IEnumerable<TModel>> Delete(int id)
        {
            var result = await _crudService.Delete(id);

            return result;
        }
    }
}