using eMovieFinder.Model.Entities;

namespace eMovieFinder.Services.Interfaces.ML
{
    public interface IRecommenderPredictService
    {
        List<Movie> RecommendMovieItems(List<int> favouriteMoviesIds);
    }
}
