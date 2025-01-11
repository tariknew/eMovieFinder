using eMovieFinder.Database.Context;
using eMovieFinder.Model.ML;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces.ML;
using MapsterMapper;
using Microsoft.ML;

namespace eMovieFinder.Services.Services.ML
{
    public class RecommenderPredictService : IRecommenderPredictService
    {
        private readonly EMFContext _context;
        private readonly IMapper _mapper;
        static MLContext mlContext = new MLContext();
        public RecommenderPredictService(EMFContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public List<Model.Entities.Movie> RecommendMovieItems(List<int> favouriteMoviesIds)
        {
            try
            {
                var result = new List<Model.Entities.Movie>();

                DataViewSchema modelSchema;

                string modelsPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "RecommenderModels");
                string ordersModelPath = Path.Combine(modelsPath, "moviefavouritesmodel.zip");

                ITransformer _model = mlContext.Model.Load(ordersModelPath, out modelSchema);

                foreach (var movie in favouriteMoviesIds)
                {
                    var movieItems = _context.Movies.Where(x => x.Id != movie).ToList();
                    var predictionResult = new List<Tuple<Database.Entities.Movie, float>>();

                    foreach (var movieItem in movieItems)
                    {
                        var predictionengine = mlContext.Model
                            .CreatePredictionEngine<ProductEntry, CopurchasePrediction>(_model);

                        var prediction = predictionengine.Predict(
                            new ProductEntry()
                            {
                                ProductId = (uint)movie,
                                CoPurchaseProductId = (uint)movieItem.Id
                            });

                        predictionResult.Add(new Tuple<Database.Entities.Movie, float>(movieItem, prediction.Score));
                    }

                    var finalResults = predictionResult.OrderByDescending(x => x.Item2)
                        .Select(x => x.Item1)
                        .FirstOrDefault();

                    result.Add(_mapper.Map<Model.Entities.Movie>(finalResults));
                }

                return result.Distinct().ToList();
            }
            catch (Exception)
            {
                throw new UserException("Warning! Recommender is currently not available");
            }
        }
    }
}
