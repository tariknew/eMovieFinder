using eMovieFinder.Model.Dtos.Requests.MovieCategory;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface IMovieCategoryService : ICRUDService<MovieCategory, MovieCategoryInsertRequest, MovieCategoryUpdateRequest, MovieCategorySearchObject> { }
}