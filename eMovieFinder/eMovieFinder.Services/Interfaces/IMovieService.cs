using eMovieFinder.Model.Dtos.Requests.Movie;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface IMovieService : ICRUDService<Movie, MovieInsertRequest, MovieUpdateRequest, MovieSearchObject> { }
}