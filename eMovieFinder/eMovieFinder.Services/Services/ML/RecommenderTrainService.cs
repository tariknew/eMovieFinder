using eMovieFinder.Database.Context;
using eMovieFinder.Model.ML;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces.ML;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Trainers;

namespace eMovieFinder.Services.Services.ML
{
    public class RecommenderTrainService : IRecommenderTrainService
    {
        private readonly EMFContext _context;
        private static object isLocked = new object();
        static MLContext mlContext = new MLContext();
        public RecommenderTrainService(EMFContext context)
        {
            _context = context;
        }
        public void TrainFavouriteMoviesModel()
        {
            lock (isLocked)
            {
                var movieFavourites = _context.Users.Include(x => x.MovieFavourites).ToList();

                if (!_context.MovieFavourites.Any() || movieFavourites.All(x => x.MovieFavourites.Count <= 1))
                {
                    throw new UserException("Recommender can't be trained. At least one user need to have two favourite movies in the database");
                }

                var data = new List<ProductEntry>();
                ITransformer model = null;

                foreach (var movieFavourite in movieFavourites)
                {
                    if (movieFavourite.MovieFavourites.Count > 1)
                    {
                        var movieFavouritesIds = movieFavourite.MovieFavourites.Select(y => y.MovieId).ToList();

                        movieFavouritesIds.ForEach(y =>
                        {
                            var relatedItems = movieFavourite.MovieFavourites.Where(z => z.MovieId != y).ToList();

                            relatedItems.ForEach(z =>
                            {
                                data.Add(new ProductEntry
                                {
                                    ProductId = (uint)y,
                                    CoPurchaseProductId = (uint)z.MovieId
                                });
                            });
                        });
                    }
                }

                var trainData = mlContext.Data.LoadFromEnumerable(data);

                MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options
                {
                    MatrixColumnIndexColumnName = nameof(ProductEntry.ProductId),
                    MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductId),
                    LabelColumnName = "Label",
                    LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                    Alpha = 0.01,
                    Lambda = 0.025,
                    NumberOfIterations = 100,
                    C = 0.00001
                };

                var trainer = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                model = trainer.Fit(trainData);

                try
                {
                    string modelsPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "RecommenderModels");
                    Directory.CreateDirectory(modelsPath);
                    string ordersModelPath = Path.Combine(modelsPath, "moviefavouritesmodel.zip");

                    mlContext.Model.Save(model, trainData.Schema, ordersModelPath);
                }
                catch (Exception)
                {
                    throw new UserException("Server busy. Try again later");
                }
            }
        }
    }
}
