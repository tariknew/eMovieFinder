using eMovieFinder.Model.Dtos.Requests.MovieFavourite;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface IMovieFavouriteService : ICRUDService<MovieFavourite, MovieFavouriteInsertRequest, MovieFavouriteUpdateRequest, MovieFavouriteSearchObject> { }
}