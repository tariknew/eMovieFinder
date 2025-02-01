using eMovieFinder.Model.Dtos.Requests.Country;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class CountryController : BaseCRUDController<Model.Entities.Country, Database.Entities.Country, CountryInsertRequest, CountryUpdateRequest, CountrySearchObject>
    {
        public CountryController(ICountryService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Country> Insert([FromBody] CountryInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Country> Update(int id, [FromBody] CountryUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<IEnumerable<Model.Entities.Country>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}