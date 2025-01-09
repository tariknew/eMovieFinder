using eMovieFinder.Model.Dtos.Requests.Actor;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface IActorService : ICRUDService<Actor, ActorInsertRequest, ActorUpdateRequest, ActorSearchObject> { }
}