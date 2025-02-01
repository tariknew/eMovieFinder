using eMovieFinder.Model.Dtos.Requests.Director;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface IDirectorService : ICRUDService<Director, DirectorInsertRequest, DirectorUpdateRequest, DirectorSearchObject> { }
}