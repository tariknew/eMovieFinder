using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.Dtos.Requests.Movie;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace eMovieFinder.Services.Services
{
    public class MovieService : BaseCRUDService<Model.Entities.Movie, Movie, MovieInsertRequest, MovieUpdateRequest, MovieSearchObject>
    , IMovieService
    {
        private readonly ILogger<MovieService> _logger;
        private readonly UserManager<IdentityUser<int>> _userManager;
        public MovieService(EMFContext context, IMapper mapper, ILogger<MovieService> logger,
            IHttpContextAccessor httpContextAccessor, UserManager<IdentityUser<int>> userManager)
            : base(context, mapper, httpContextAccessor)
        {
            _logger = logger;
            _userManager = userManager;
        }
        public override IQueryable<Movie> AddFilter(MovieSearchObject search, IQueryable<Movie> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.Title))
            {
                query = query.Where(x => x.Title.Contains(search.Title));
            }
            if (search?.CategoryId != null && search?.CategoryId != 0)
            {
                query = query.Where(x => x.MovieCategories.Any(x => x.CategoryId == search.CategoryId));
            }
            if (search?.PriceGTE != null)
            {
                query = query.Where(x => x.Price >= search.PriceGTE);
            }
            if (search?.PriceLTE != null)
            {
                query = query.Where(x => x.Price <= search.PriceLTE);
            }
            if (search?.IsAdministratorPanel == false)
            {
                query = query.Where(x => x.MovieState == MovieStatesEnumeration.MovieStatesEnum.Published);
            }

            query = ApplyInclude(search, query);

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "LastAddedMovies":
                        query = SortBy(query, m => m.CreationDate,
                        search.IsDescending.Value); break;
                    case "AverageRating":
                        query = SortBy(query, m => m.AverageRating,
                        search.IsDescending.Value); break;
                    case "Price":
                        query = SortBy(query, m => m.Price,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override async Task BeforeInsert(MovieInsertRequest request, Movie entity)
        {
            byte[] ImageBytes = ImageHelper.ConvertImageToBytes(request.ImagePlainText);

            entity.Image = ImageBytes;

            if (request.MovieState == 0)
            {
                entity.MovieState = MovieStatesEnumeration.MovieStatesEnum.Draft;
            }
            if (request.MovieState == 1)
            {
                entity.MovieState = MovieStatesEnumeration.MovieStatesEnum.Published;
            }
            if (request.MovieState == 2)
            {
                entity.MovieState = MovieStatesEnumeration.MovieStatesEnum.Discounted;
            }
        }
        public override void AfterInsert(MovieInsertRequest request, Movie entity, Model.Entities.Movie model)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie' doesn't exist");
            }

            foreach (var category in request.Categories)
            {
                var movieCategory = new MovieCategory
                {
                    CategoryId = category,
                    MovieId = entity.Id,
                    CreationDate = entity.CreationDate,
                    CreatedById = entity.CreatedById
                };
                _context.MovieCategories.Add(movieCategory);
            }
            foreach (var actor in request.Actors)
            {
                var movieActor = new MovieActor
                {
                    ActorId = actor,
                    MovieId = entity.Id,
                    CreationDate = entity.CreationDate,
                    CreatedById = entity.CreatedById
                };
                _context.MovieActors.Add(movieActor);
            }
            _context.SaveChanges();
        }
        public override void BeforeUpdate(MovieUpdateRequest request, Movie entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie' doesn't exist");
            }

            if (!string.IsNullOrEmpty(request.ImagePlainText))
            {
                byte[] ImageBytes = ImageHelper.ConvertImageToBytes(request.ImagePlainText);

                entity.Image = ImageBytes;
            }
            if (!string.IsNullOrEmpty(request.Title))
            {
                entity.Title = request.Title;
            }
            if (request.ReleaseDate.HasValue)
            {
                entity.ReleaseDate = request.ReleaseDate.Value;
            }
            if (request.Duration.HasValue)
            {
                entity.Duration = request.Duration.Value;
            }
            if (request.DirectorId.HasValue)
            {
                entity.DirectorId = request.DirectorId.Value;
            }
            if (request.CountryId.HasValue)
            {
                entity.CountryId = request.CountryId.Value;
            }
            if (!string.IsNullOrEmpty(request.TrailerLink))
            {
                entity.TrailerLink = request.TrailerLink;
            }
            if (!string.IsNullOrEmpty(request.StoryLine))
            {
                entity.StoryLine = request.StoryLine;
            }
            if (request.Price.HasValue)
            {
                entity.Price = request.Price.Value;
            }
            if (request.Discount.HasValue)
            {
                entity.Discount = request.Discount.Value;
            }
            if (request.AverageRating.HasValue)
            {
                entity.AverageRating = request.AverageRating.Value;
            }
            if (request.MovieState == 0)
            {
                entity.MovieState = MovieStatesEnumeration.MovieStatesEnum.Draft;
            }
            if (request.MovieState == 1)
            {
                entity.MovieState = MovieStatesEnumeration.MovieStatesEnum.Published;
            }
            if (request.MovieState == 2)
            {
                entity.MovieState = MovieStatesEnumeration.MovieStatesEnum.Discounted;
            }
        }
        public override void AfterUpdate(MovieUpdateRequest request, Movie entity, Model.Entities.Movie model)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie' doesn't exist");
            }

            if (request.Categories.Any())
            {
                var movieCategories = _context.MovieCategories.Where(x => x.MovieId == entity.Id);
                _context.MovieCategories.RemoveRange(movieCategories);

                foreach (var category in request.Categories)
                {
                    var movieCategory = new MovieCategory
                    {
                        CategoryId = category,
                        MovieId = entity.Id,
                        ModifiedDate = entity.ModifiedDate,
                        ModifiedById = entity.ModifiedById
                    };
                    _context.MovieCategories.Add(movieCategory);
                }

                _context.SaveChanges();
            }
            if (request.Actors.Any())
            {
                var movieActors = _context.MovieActors.Where(x => x.MovieId == entity.Id);
                _context.MovieActors.RemoveRange(movieActors);

                foreach (var actor in request.Actors)
                {
                    var movieActor = new MovieActor
                    {
                        ActorId = actor,
                        MovieId = entity.Id,
                        ModifiedDate = entity.ModifiedDate,
                        ModifiedById = entity.ModifiedById
                    };
                    _context.MovieActors.Add(movieActor);
                }
                _context.SaveChanges();
            }
        }
        public override async Task BeforeDeleteAsync(Movie entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie' doesn't exist");
            }

            var movieCategories = _context.MovieCategories.Where(x => x.MovieId == entity.Id);
            _context.MovieCategories.RemoveRange(movieCategories);

            var movieActors = _context.MovieActors.Where(x => x.MovieId == entity.Id);
            _context.MovieActors.RemoveRange(movieActors);

            var movieFavourites = _context.MovieFavourites.Where(x => x.MovieId == entity.Id);
            _context.MovieFavourites.RemoveRange(movieFavourites);

            var movieReviews = _context.MovieReviews.Where(x => x.MovieId == entity.Id);
            _context.MovieReviews.RemoveRange(movieReviews);

            var movieOrders = _context.OrderMovies.Where(x => x.MovieId == entity.Id).ToList();

            var orderIds = movieOrders.Select(x => x.OrderId).Distinct().ToList();

            _context.OrderMovies.RemoveRange(movieOrders);

            foreach (var orderId in orderIds)
            {
                var order = await _context.Orders.FindAsync(orderId);

                if (order != null)
                {
                    _context.Orders.Remove(order);
                }
            }

            var movieCartItems = _context.CartItems.Where(x => x.MovieId == entity.Id).ToList();

            var cartIds = movieCartItems.Select(x => x.CartId).Distinct().ToList();

            _context.CartItems.RemoveRange(movieCartItems);

            foreach (var cartId in cartIds)
            {
                var cart = await _context.Carts.FindAsync(cartId);

                if (cart != null)
                {
                    _context.Carts.Remove(cart);
                }
            }

            await _context.SaveChangesAsync();
        }
        public override async Task<Model.Entities.Movie> GetById(int id, MovieSearchObject search)
        {
            var movieQuery = _context.Movies.AsQueryable();

            movieQuery = ApplyInclude(search, movieQuery);

            var movie = movieQuery.FirstOrDefault(x => x.Id == id);

            if (movie == null)
            {
                throw new UserException($"'Movie' doesn't exist");
            }

            var model = _mapper.Map<Model.Entities.Movie>(movie);

            var result = await GetIdentityUserInfoForGet(model);

            return result;
        }
        private IQueryable<Movie> ApplyInclude(MovieSearchObject search, IQueryable<Movie> query)
        {
            if (search.IsDirectorIncluded == true)
            {
                query = query.Include(x => x.Director);
            }
            if (search.IsCountryIncluded == true)
            {
                query = query.Include(x => x.Country);
            }
            if (search.IsMovieReviewsIncluded == true)
            {
                query = query.Include(x => x.MovieReviews)
                    .ThenInclude(x => x.User)
                    .ThenInclude(x => x.IdentityUser);
            }
            if (search.IsMovieCategoriesIncluded == true)
            {
                query = query.Include(x => x.MovieCategories).ThenInclude(x => x.Category);
            }
            if (search.IsMovieActorsIncluded == true)
            {
                query = query.Include(x => x.MovieActors).ThenInclude(x => x.Actor);
            }

            return query;
        }
        public override async Task<Model.Entities.Movie> GetIdentityUserInfoForGet(Model.Entities.Movie model)
        {
            foreach (var movieReview in model.MovieReviews)
            {
                var identityUser = await _userManager.FindByIdAsync(movieReview.User.IdentityUserId.ToString());

                if (identityUser != null)
                {
                    movieReview.User.Username = identityUser.UserName;
                }
            }

            return model;
        }
    }
}