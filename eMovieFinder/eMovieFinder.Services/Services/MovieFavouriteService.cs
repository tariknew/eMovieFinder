using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Model.Dtos.Requests.MovieFavourite;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Services.Services
{
    public class MovieFavouriteService : BaseCRUDService<Model.Entities.MovieFavourite, MovieFavourite, MovieFavouriteInsertRequest, MovieFavouriteUpdateRequest, MovieFavouriteSearchObject>
    , IMovieFavouriteService
    {
        public MovieFavouriteService(EMFContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper, httpContextAccessor) { }
        public override IQueryable<MovieFavourite> AddFilter(MovieFavouriteSearchObject search, IQueryable<MovieFavourite> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.MovieTitle))
            {
                query = query.Where(x => x.Movie.Title.Contains(search.MovieTitle));
            }
            if (search?.MovieId != null && search?.MovieId != 0)
            {
                query = query.Where(x => x.Movie.Id == search.MovieId);
            }
            if (search?.UserId != null && search?.UserId != 0)
            {
                query = query.Where(x => x.User.Id == search.UserId);
            }

            query = ApplyInclude(search, query);

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "LastAddedFavouriteMovies":
                        query = SortBy(query, m => m.CreationDate,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override async Task BeforeInsert(MovieFavouriteInsertRequest request, MovieFavourite entity)
        {
            var existingFavourite = _context.MovieFavourites
                .Any(x => x.UserId == request.UserId && x.MovieId == request.MovieId);

            if (existingFavourite)
            {
                throw new UserException($"You can't add a movie that is already in favourites");
            }
        }
        public override void BeforeUpdate(MovieFavouriteUpdateRequest request, MovieFavourite entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Favourite movie' doesn't exist");
            }
        }
        public override void BeforeDelete(MovieFavourite entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Favourite movie' doesn't exist");
            }
        }
        public override async Task<Model.Entities.MovieFavourite> GetById(int id, MovieFavouriteSearchObject search)
        {
            var movieFavouriteQuery = _context.MovieFavourites.AsQueryable();

            movieFavouriteQuery = ApplyInclude(search, movieFavouriteQuery);

            var movieFavourite = movieFavouriteQuery.FirstOrDefault(x => x.Id == id);

            if (movieFavourite == null)
            {
                throw new UserException($"'Favourite movie' doesn't exist");
            }

            return _mapper.Map<Model.Entities.MovieFavourite>(movieFavourite);
        }
        private IQueryable<MovieFavourite> ApplyInclude(MovieFavouriteSearchObject search, IQueryable<MovieFavourite> query)
        {
            if (search.IsUserIncluded == true)
            {
                query = query
                    .Include(x => x.User)
                    .ThenInclude(x => x.IdentityUser);
            }
            if (search.IsMovieIncluded == true)
            {
                query = query.Include(x => x.Movie);
            }

            return query;
        }
    }
}