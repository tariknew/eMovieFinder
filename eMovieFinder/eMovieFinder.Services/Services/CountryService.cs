using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Model.Dtos.Requests.Country;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;

namespace eMovieFinder.Services.Services
{
    public class CountryService : BaseCRUDService<Model.Entities.Country, Country, CountryInsertRequest, CountryUpdateRequest, CountrySearchObject>
    , ICountryService
    {
        public CountryService(EMFContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper, httpContextAccessor) { }
        public override IQueryable<Country> AddFilter(CountrySearchObject search, IQueryable<Country> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.CountryName))
            {
                query = query.Where(x => x.CountryName.Contains(search.CountryName));
            }

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "LastAddedCountries":
                        query = SortBy(query, m => m.CreationDate,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override void BeforeUpdate(CountryUpdateRequest request, Country entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Country' doesn't exist");
            }
        }
        public override void BeforeDelete(Country entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Country' doesn't exist");
            }
            else
            {
                var hasMovies = _context.Movies.Any(movie => movie.CountryId == entity.Id);
                var hasActors = _context.Actors.Any(actor => actor.CountryId == entity.Id);

                if (hasMovies || hasActors)
                {
                    var moviesWithCountry = _context.Movies
                        .Where(movie => movie.CountryId == entity.Id)
                        .ToList();

                    var actorsWithCountry = _context.Actors
                        .Where(actor => actor.CountryId == entity.Id)
                        .ToList();

                    foreach (var movie in moviesWithCountry)
                    {
                        movie.CountryId = null;
                    }

                    foreach (var actor in actorsWithCountry)
                    {
                        actor.CountryId = null;
                    }

                    _context.SaveChanges();
                }
            }
        }
        public override void BeforeGetById(Country entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Country' doesn't exist");
            }
        }
    }
}