using eMovieFinder.Model.Dtos.Requests.MovieReview;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface IMovieReviewService : ICRUDService<MovieReview, MovieReviewInsertRequest, MovieReviewUpdateRequest, MovieReviewSearchObject> { }
}