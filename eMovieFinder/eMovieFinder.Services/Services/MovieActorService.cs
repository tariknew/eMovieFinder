using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Model.Dtos.Requests.MovieActor;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Services.Services
{
    public class MovieActorService : BaseCRUDService<Model.Entities.MovieActor, MovieActor, MovieActorInsertRequest, MovieActorUpdateRequest, MovieActorSearchObject>
    , IMovieActorService
    {
        public MovieActorService(EMFContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper, httpContextAccessor) { }
        public override IQueryable<MovieActor> AddFilter(MovieActorSearchObject search, IQueryable<MovieActor> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.FullName))
            {
                query = query
                    .Where(x => search.FullName == null || (x.Actor.FirstName + " " + x.Actor.LastName)
                    .StartsWith(search.FullName) || (x.Actor.LastName + " " + x.Actor.FirstName)
                    .StartsWith(search.FullName));
            }
            if (search?.MovieId != null && search?.MovieId != 0)
            {
                query = query.Where(x => x.Movie.Id == search.MovieId);
            }

            query = ApplyInclude(search, query);

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "LastAddedMovieActors":
                        query = SortBy(query, m => m.CreationDate,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override void BeforeUpdate(MovieActorUpdateRequest request, MovieActor entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie actor' doesn't exist");
            }
        }
        public override void BeforeDelete(MovieActor entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie actor' doesn't exist");
            }
        }
        public override async Task<List<Model.Entities.MovieActor>> FillTheModel(List<Model.Entities.MovieActor> model)
        {
            foreach (var viewModel in model)
            {
                var movie = await _context.Movies.FindAsync(viewModel.MovieId);

                if (movie != null)
                {
                    viewModel.MovieTitle = movie.Title;
                }
            }

            return model;
        }
        public override async Task<Model.Entities.MovieActor> GetById(int id, MovieActorSearchObject search)
        {
            var movieActorQuery = _context.MovieActors.AsQueryable();

            movieActorQuery = ApplyInclude(search, movieActorQuery);

            var movieActor = movieActorQuery.FirstOrDefault(x => x.Id == id);

            if (movieActor == null)
            {
                throw new UserException($"'Movie actor' doesn't exist");
            }

            return _mapper.Map<Model.Entities.MovieActor>(movieActor);
        }
        private IQueryable<MovieActor> ApplyInclude(MovieActorSearchObject search, IQueryable<MovieActor> query)
        {
            if (search.IsMovieIncluded == true)
            {
                query = query.Include(x => x.Movie);
            }
            if (search.IsActorIncluded == true)
            {
                query = query.Include(x => x.Actor)
                    .ThenInclude(x => x.Country);
            }

            return query;
        }
    }
}