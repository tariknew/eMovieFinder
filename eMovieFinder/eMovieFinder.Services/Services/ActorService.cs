using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.Dtos.Requests.Actor;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Services.Services
{
    public class ActorService : BaseCRUDService<Model.Entities.Actor, Actor, ActorInsertRequest, ActorUpdateRequest, ActorSearchObject>
    , IActorService
    {
        public ActorService(EMFContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper, httpContextAccessor) { }
        public override IQueryable<Actor> AddFilter(ActorSearchObject search, IQueryable<Actor> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.FullName))
            {
                query = query
                    .Where(x => search.FullName == null || (x.FirstName + " " + x.LastName)
                    .StartsWith(search.FullName) || (x.LastName + " " + x.FirstName)
                    .StartsWith(search.FullName));
            }

            query = query.Include(x => x.Country);

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "LastAddedActors":
                        query = SortBy(query, m => m.CreationDate,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override async Task BeforeInsert(ActorInsertRequest request, Actor entity)
        {
            byte[] ImageBytes = ImageHelper.ConvertImageToBytes(request.ImagePlainText);

            entity.Image = ImageBytes;
        }
        public override void BeforeUpdate(ActorUpdateRequest request, Actor entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie actor' doesn't exist");
            }

            if (!string.IsNullOrEmpty(request.FirstName))
            {
                entity.FirstName = request.FirstName;
            }
            if (!string.IsNullOrEmpty(request.LastName))
            {
                entity.LastName = request.LastName;
            }
            if (!string.IsNullOrEmpty(request.ImagePlainText))
            {
                byte[] ImageBytes = ImageHelper.ConvertImageToBytes(request.ImagePlainText);

                entity.Image = ImageBytes;
            }
            if (request.BirthDate.HasValue)
            {
                entity.BirthDate = request.BirthDate.Value;
            }
            if (request.CountryId.HasValue)
            {
                entity.CountryId = request.CountryId.Value;
            }
            if (!string.IsNullOrEmpty(request.IMDbLink))
            {
                entity.IMDbLink = request.IMDbLink;
            }
            if (!string.IsNullOrEmpty(request.Biography))
            {
                entity.Biography = request.Biography;
            }
        }
        public override void BeforeDelete(Actor entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie actor' doesn't exist");
            }

            var movieActors = _context.MovieActors.Where(x => x.ActorId == entity.Id);
            _context.MovieActors.RemoveRange(movieActors);
        }
        public override async Task<Model.Entities.Actor> GetById(int id, ActorSearchObject search = null)
        {
            var actor = _context.Actors
                .Include(x => x.Country)
                .FirstOrDefault(x => x.Id == id);

            if (actor == null)
            {
                throw new UserException($"'Movie actor' doesn't exist");
            }

            return _mapper.Map<Model.Entities.Actor>(actor);
        }
    }
}