using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    public class BaseReadController<TModel, TSearch> : ControllerBase where TModel : class where TSearch : BaseSearchObject
    {
        private readonly IReadService<TModel, TSearch> _service;
        public BaseReadController(IReadService<TModel, TSearch> service)
        {
            _service = service;
        }
        [HttpGet]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public virtual Task<PageResultObject<TModel>> Get([FromQuery] TSearch search = null)
        {
            return _service.Get(search);
        }
        [HttpGet("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public virtual async Task<TModel> GetById(int id, [FromQuery] TSearch search = null)
        {
            var result = await _service.GetById(id, search);

            return result;
        }
    }
}