using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Model.Dtos.Requests.MovieCategory;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Services.Services
{
    public class MovieCategoryService : BaseCRUDService<Model.Entities.MovieCategory, MovieCategory, MovieCategoryInsertRequest, MovieCategoryUpdateRequest, MovieCategorySearchObject>
    , IMovieCategoryService
    {
        public MovieCategoryService(EMFContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper, httpContextAccessor) { }
        public override IQueryable<MovieCategory> AddFilter(MovieCategorySearchObject search, IQueryable<MovieCategory> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.CategoryName))
            {
                query = query.Where(x => x.Category.CategoryName.Contains(search.CategoryName));
            }
            if (search?.MovieId != null && search?.MovieId != 0)
            {
                query = query.Where(x => x.Movie.Id == search.MovieId);
            }

            query = ApplyInclude(search, query);

            return query;
        }
        public override void BeforeUpdate(MovieCategoryUpdateRequest request, MovieCategory entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie category' doesn't exist");
            }
        }
        public override void BeforeDelete(MovieCategory entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie category' doesn't exist");
            }
        }
        public override async Task<Model.Entities.MovieCategory> GetById(int id, MovieCategorySearchObject search)
        {
            var movieCategoryQuery = _context.MovieCategories.AsQueryable();

            movieCategoryQuery = ApplyInclude(search, movieCategoryQuery);

            var movieCategory = movieCategoryQuery.FirstOrDefault(x => x.Id == id);

            if (movieCategory == null)
            {
                throw new UserException($"'Movie category' doesn't exist");
            }

            return _mapper.Map<Model.Entities.MovieCategory>(movieCategory);
        }
        private IQueryable<MovieCategory> ApplyInclude(MovieCategorySearchObject search, IQueryable<MovieCategory> query)
        {
            if (search.IsMovieIncluded == true)
            {
                query = query.Include(x => x.Movie);
            }
            if (search.IsCategoryIncluded == true)
            {
                query = query.Include(x => x.Category);
            }

            return query;
        }
    }
}