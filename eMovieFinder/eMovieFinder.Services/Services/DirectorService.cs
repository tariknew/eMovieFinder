using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Model.Dtos.Requests.Director;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;

namespace eMovieFinder.Services.Services
{
    public class DirectorService : BaseCRUDService<Model.Entities.Director, Director, DirectorInsertRequest, DirectorUpdateRequest, DirectorSearchObject>
    , IDirectorService
    {
        public DirectorService(EMFContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper, httpContextAccessor) { }
        public override IQueryable<Director> AddFilter(DirectorSearchObject search, IQueryable<Director> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.FullName))
            {
                query = query
                    .Where(x => search.FullName == null || (x.FirstName + " " + x.LastName)
                    .StartsWith(search.FullName) || (x.LastName + " " + x.FirstName)
                    .StartsWith(search.FullName));
            }

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "LastAddedDirectors":
                        query = SortBy(query, m => m.CreationDate,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override void BeforeUpdate(DirectorUpdateRequest request, Director entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Director' doesn't exist");
            }
        }
        public override void BeforeDelete(Director entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Director' doesn't exist");
            }
            else
            {
                var hasDirector = _context.Movies.Any(director => director.DirectorId == entity.Id);

                if (hasDirector)
                {
                    var moviesWithDirector = _context.Movies
                        .Where(director => director.DirectorId == entity.Id)
                        .ToList();

                    foreach (var director in moviesWithDirector)
                    {
                        director.DirectorId = null;
                    }
                }
            }
        }
        public override void BeforeGetById(Director entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Director' doesn't exist");
            }
        }
    }
}