using eMovieFinder.Model.Dtos.Requests.Country;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface ICountryService : ICRUDService<Country, CountryInsertRequest, CountryUpdateRequest, CountrySearchObject> { }
}