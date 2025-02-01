using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Model.Dtos.Requests.Category;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;

namespace eMovieFinder.Services.Services
{
    public class CategoryService : BaseCRUDService<Model.Entities.Category, Category, CategoryInsertRequest, CategoryUpdateRequest, CategorySearchObject>
    , ICategoryService
    {
        public CategoryService(EMFContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper, httpContextAccessor) { }
        public override IQueryable<Category> AddFilter(CategorySearchObject search, IQueryable<Category> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.CategoryName))
            {
                query = query.Where(x => x.CategoryName.Contains(search.CategoryName));
            }

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "LastAddedCategories":
                        query = SortBy(query, m => m.CreationDate,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override void BeforeUpdate(CategoryUpdateRequest request, Category entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Category' doesn't exist");
            }
        }
        public override void BeforeDelete(Category entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Category' doesn't exist");
            }
            else
            {
                var hasMovieCategories = _context.Movies
                    .Any(movie => movie.MovieCategories.Any(mc => mc.CategoryId == entity.Id));

                if (hasMovieCategories)
                {
                    var movieCategories = _context.MovieCategories.Where(x => x.CategoryId == entity.Id);
                    _context.MovieCategories.RemoveRange(movieCategories);
                }
            }
        }
        public override void BeforeGetById(Category entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Category' doesn't exist");
            }
        }
    }
}