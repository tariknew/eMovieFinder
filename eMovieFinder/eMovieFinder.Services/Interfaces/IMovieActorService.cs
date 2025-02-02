using eMovieFinder.Model.Dtos.Requests.MovieActor;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface IMovieActorService : ICRUDService<MovieActor, MovieActorInsertRequest, MovieActorUpdateRequest, MovieActorSearchObject> { }
}