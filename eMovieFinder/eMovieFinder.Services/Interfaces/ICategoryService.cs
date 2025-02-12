using eMovieFinder.Model.Dtos.Requests.Category;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface ICategoryService : ICRUDService<Category, CategoryInsertRequest, CategoryUpdateRequest, CategorySearchObject> { }
}