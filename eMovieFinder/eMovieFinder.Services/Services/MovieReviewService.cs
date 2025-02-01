using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Model.Dtos.Requests.MovieReview;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Services.Services
{
    public class MovieReviewService : BaseCRUDService<Model.Entities.MovieReview, MovieReview, MovieReviewInsertRequest, MovieReviewUpdateRequest, MovieReviewSearchObject>
    , IMovieReviewService
    {
        private readonly UserManager<IdentityUser<int>> _userManager;
        public MovieReviewService(EMFContext context, IMapper mapper,
            IHttpContextAccessor httpContextAccessor, UserManager<IdentityUser<int>> userManager)
            : base(context, mapper, httpContextAccessor)
        {
            _userManager = userManager;
        }
        public override IQueryable<MovieReview> AddFilter(MovieReviewSearchObject search, IQueryable<MovieReview> query)
        {
            if (search?.UserId != null && search?.UserId != 0)
            {
                query = query.Where(x => x.User.Id == search.UserId);
            }
            if (search?.MovieId != null && search?.MovieId != 0)
            {
                query = query.Where(x => x.Movie.Id == search.MovieId);
            }

            query = ApplyInclude(search, query);

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "Rating":
                        query = SortBy(query, m => m.Rating,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override async Task<Model.Entities.MovieReview> GetIdentityUserInfoForInsert(Model.Entities.MovieReview model)
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(x => x.Id == model.UserId);

            var identityUser = await _userManager.FindByIdAsync(user.IdentityUserId.ToString());

            if (identityUser != null && user != null)
            {
                model.User = _mapper.Map<Model.Entities.User>(user);

                model.User.Username = identityUser.UserName;
            }

            return model;
        }
        public override async Task BeforeInsert(MovieReviewInsertRequest request, MovieReview entity)
        {
            var existingReview = _context.MovieReviews
                .Any(r => r.MovieId == request.MovieId && r.UserId == request.UserId);

            if (existingReview)
            {
                throw new UserException("You have already submitted a review for this movie");
            }
        }
        public override void AfterInsert(MovieReviewInsertRequest request, MovieReview entity, Model.Entities.MovieReview model)
        {
            CalculateMovieAverageRating(request.MovieId, model);
        }
        public override void BeforeUpdate(MovieReviewUpdateRequest request, MovieReview entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie review' doesn't exist");
            }
        }
        public override void AfterUpdate(MovieReviewUpdateRequest request, MovieReview entity, Model.Entities.MovieReview model)
        {
            if (request.MovieId.HasValue)
            {
                int movieId = request.MovieId.Value;

                CalculateMovieAverageRating(movieId, model);
            }
            else
            {
                throw new UserException($"Can't calculate average score 'Movie' doesn't exist");
            }
        }
        public override async Task<IEnumerable<Model.Entities.MovieReview>> Delete(int id)
        {
            var movieReview = _context.MovieReviews.Find(id);

            BeforeDelete(movieReview);

            _context.MovieReviews.Remove(movieReview);

            _context.SaveChanges();

            var mappedModel = _mapper.Map<Model.Entities.MovieReview>(movieReview);

            AfterDelete(movieReview, mappedModel);

            return new List<Model.Entities.MovieReview> { mappedModel };
        }
        public override void BeforeDelete(MovieReview entity)
        {
            if (entity == null)
            {
                throw new UserException($"'Movie review' doesn't exist");
            }
        }
        public override void AfterDelete(MovieReview entity, Model.Entities.MovieReview model)
        {
            CalculateMovieAverageRating(entity.MovieId, model);
        }
        public override async Task<Model.Entities.MovieReview> GetById(int id, MovieReviewSearchObject search)
        {
            var movieReviewQuery = _context.MovieReviews.AsQueryable();

            movieReviewQuery = ApplyInclude(search, movieReviewQuery);

            var movieReview = movieReviewQuery.FirstOrDefault(x => x.Id == id);

            if (movieReview == null)
            {
                throw new UserException($"'Movie review' doesn't exist");
            }

            return _mapper.Map<Model.Entities.MovieReview>(movieReview);
        }
        private IQueryable<MovieReview> ApplyInclude(MovieReviewSearchObject search, IQueryable<MovieReview> query)
        {
            if (search.IsUserIncluded == true)
            {
                query = query.Include(x => x.User);
            }
            if (search.IsMovieIncluded == true)
            {
                query = query.Include(x => x.Movie);
            }

            return query;
        }
        private void CalculateMovieAverageRating(int movieId, Model.Entities.MovieReview model)
        {
            var movie = _context.Movies.FirstOrDefault(x => x.Id == movieId);

            if (movie == null)
            {
                throw new UserException($"'Movie' doesn't exist");
            }
            if (_context.MovieReviews.Any(x => x.MovieId == movieId))
            {
                double? averageScore = _context.MovieReviews
                .Where(x => x.MovieId == movieId)
                .Select(x => x.Rating)
                .Average();

                movie.AverageRating = averageScore.HasValue ? Math.Round(averageScore.Value, 2) : 0.0;
                movie.ModifiedDate = model.ModifiedDate;
                movie.ModifiedById = model.ModifiedById;

                string formattedAverageRating = movie.AverageRating.GetValueOrDefault() % 1 == 0
                    ? movie.AverageRating.GetValueOrDefault().ToString("0.0")
                    : movie.AverageRating.GetValueOrDefault().ToString("0.00");

                model.FormattedAverageRating = formattedAverageRating;

                _context.SaveChanges();
            }
            else
            {
                movie.AverageRating = 0.0;
                movie.ModifiedDate = model.ModifiedDate;
                movie.ModifiedById = model.ModifiedById;
                model.FormattedAverageRating = "0.0";

                _context.SaveChanges();
            }
        }
    }
}