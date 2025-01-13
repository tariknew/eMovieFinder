using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.Dtos.Requests.Cart;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Services.Services
{
    public class CartService : BaseCRUDService<Model.Entities.Cart, Cart, CartInsertRequest, object, CartSearchObject>
    , ICartService
    {
        private readonly UserManager<IdentityUser<int>> _userManager;
        public CartService(EMFContext context, IMapper mapper,
            IHttpContextAccessor httpContextAccessor, UserManager<IdentityUser<int>> userManager)
            : base(context, mapper, httpContextAccessor)
        {
            _userManager = userManager;
        }
        public override IQueryable<Cart> AddFilter(CartSearchObject search, IQueryable<Cart> query)
        {
            if (search?.UserId != null && search?.UserId != 0)
            {
                query = query.Where(x => x.UserId == search.UserId);
            }
            if (search?.MovieId != null && search?.MovieId != 0)
            {
                query = query.Where(x => x.CartItems.Any(x => x.Movie.Id == search.MovieId));
            }
            if (!string.IsNullOrWhiteSpace(search?.Username))
            {
                query = query.Where(x => x.User.IdentityUser.UserName.Contains(search.Username));
            }
            if (!string.IsNullOrWhiteSpace(search?.MovieTitle))
            {
                query = query.Where(x => x.CartItems.Any(x => x.Movie.Title.Contains(search.MovieTitle)));
            }

            query = ApplyInclude(search, query);

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "CartTotalPrice":
                        query = SortBy(query, m => m.CartTotalPrice,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override async Task<Model.Entities.Cart> Insert(CartInsertRequest request)
        {
            var newCart = _mapper.Map<Cart>(request);

            await BeforeInsert(request, newCart);

            var existingCart = _context.Carts
                .FirstOrDefault(cart => cart.UserId == request.UserId);

            if (existingCart == null)
            {
                newCart.CreationDate = DateTime.Now;
                newCart.CreatedById = UserHelper.GetIdentityUserId(_httpContextAccessor);

                _context.Carts.Add(newCart);
                _context.SaveChanges();

                AfterInsert(newCart, null, request);

                return _mapper.Map<Model.Entities.Cart>(newCart);
            }
            else
            {
                var existingCartId = existingCart.Id;

                AfterInsert(newCart, existingCartId, request);

                return new Model.Entities.Cart();
            }
        }
        public override async Task BeforeInsert(CartInsertRequest request, Cart entity)
        {
            var cart = await _context.Carts
                .Include(x => x.CartItems)
                .FirstOrDefaultAsync(x => x.UserId == request.UserId);

            if (cart != null)
            {
                var movieExistsInCart = cart.CartItems
                .Any(x => x.MovieId == request.MovieId);

                if (movieExistsInCart)
                {
                    throw new UserException($"You have already added this movie to the cart");
                }
            }
        }
        private void AfterInsert(Cart entity, int? cartId, CartInsertRequest request)
        {
            if (entity == null)
            {
                throw new UserException($"'Cart' doesn't exist");
            }

            InsertCartItem(entity, cartId, request);
        }
        public override async Task<Model.Entities.Cart> Update(int id, object request)
        {
            throw new UserException("Method isn't implemented");
        }
        public override async Task<IEnumerable<Model.Entities.Cart>> Delete(int id)
        {
            throw new UserException("Method isn't implemented");
        }
        public async Task DeleteAllFromCart(int userId)
        {
            var cart = _context.Carts
                .Include(x => x.CartItems)
                .Include(x => x.User)
                .FirstOrDefault(x => x.UserId == userId);

            if (cart == null)
            {
                throw new UserException($"'Cart' doesn't exist");
            }

            _context.CartItems.RemoveRange(cart.CartItems);

            _context.Carts.RemoveRange(cart);

            _context.SaveChanges();

            var identityUserId = cart.User.IdentityUserId;

            var identityUser = await _userManager.FindByIdAsync(identityUserId.ToString());
            var currentRoles = await _userManager.GetRolesAsync(identityUser);

            if (!currentRoles.Contains("Customer"))
            {
                await _userManager.AddToRoleAsync(identityUser, "Customer");
            }

            var movieOrders = new List<OrderMovie>();

            foreach (var cartItem in cart.CartItems)
            {
                var order = new Order
                {
                    UserId = cart.UserId,
                    OrderDate = DateTime.Now
                };

                _context.Orders.Add(order);
                await _context.SaveChangesAsync();

                var movieOrder = new OrderMovie
                {
                    OrderId = order.Id,
                    MovieId = cartItem.MovieId,
                };

                movieOrders.Add(movieOrder);
            }

            _context.OrderMovies.AddRange(movieOrders);

            await _context.SaveChangesAsync();
        }
        public IEnumerable<Model.Entities.Cart> DeleteMovieFromCart(CartDeleteRequest request)
        {
            var cart = _context.Carts.Find(request.CartId);

            BeforeDelete(cart, request.MovieId);

            var cartItemsExist = _context.CartItems.Any(x => x.CartId == request.CartId);

            if (!cartItemsExist)
            {
                _context.Carts.Remove(cart);

                _context.SaveChanges();
            }

            var mappedModel = _mapper.Map<Model.Entities.Cart>(cart);

            AfterDelete(cart, mappedModel);

            return new List<Model.Entities.Cart> { mappedModel };
        }
        private void BeforeDelete(Cart entity, int movieId)
        {
            var cartItem = _context.CartItems
                .FirstOrDefault(x => x.CartId == entity.Id && x.MovieId == movieId);

            if (cartItem == null)
            {
                throw new UserException($"This movie doesn't exist in cart");
            }
            else
            {
                _context.CartItems.Remove(cartItem);

                _context.SaveChanges();
            }
        }
        private void AfterDelete(Cart entity, Model.Entities.Cart model)
        {
            var cartTotalPrice = CalculateCartTotalPrice(model.UserId, entity);

            model.CartTotalPrice = cartTotalPrice;
        }
        public override async Task<Model.Entities.Cart> GetById(int id, CartSearchObject search)
        {
            var cartQuery = _context.Carts.AsQueryable();

            cartQuery = ApplyInclude(search, cartQuery);

            var cart = cartQuery.FirstOrDefault(x => x.Id == id);

            if (cart == null)
            {
                throw new UserException($"'Cart' doesn't exist");
            }

            return _mapper.Map<Model.Entities.Cart>(cart);
        }
        private IQueryable<Cart> ApplyInclude(CartSearchObject search, IQueryable<Cart> query)
        {
            if (search.IsUserIncluded == true)
            {
                query = query.Include(x => x.User)
                    .ThenInclude(x => x.IdentityUser);
            }
            if (search.IsCartItemIncluded == true)
            {
                query = query.Include(x => x.CartItems)
                    .ThenInclude(x => x.Movie);
            }

            return query;
        }
        private void InsertCartItem(Cart entity, int? cartId, CartInsertRequest request)
        {
            var movie = _context.Movies.FirstOrDefault(x => x.Id == request.MovieId);

            if (movie == null)
            {
                throw new UserException($"'Movie' doesn't exist");
            }

            decimal moviePrice = Convert.ToDecimal(movie.Price);

            decimal movieDiscount = movie.Discount ?? 0;

            decimal cartItemPrice = (moviePrice - (moviePrice * (movieDiscount / 100)));

            var cartItem = new CartItem
            {
                CartId = cartId ?? entity.Id,
                MovieId = request.MovieId,
                FinalMoviePrice = cartItemPrice,
                CreationDate = DateTime.Now,
                CreatedById = UserHelper.GetIdentityUserId(_httpContextAccessor)
            };

            _context.CartItems.Add(cartItem);

            _context.SaveChanges();

            CalculateCartTotalPrice(request.UserId, (cartId != null ? cartId : entity));
        }
        private decimal CalculateCartTotalPrice(int userId, dynamic? entity)
        {
            var cartTotalPrice = _context.Carts
                .Where(x => x.UserId == userId)
                .SelectMany(x => x.CartItems)
                .Sum(y => y.FinalMoviePrice);

            if (entity is Cart cartEntity)
            {
                entity.CartTotalPrice = cartTotalPrice;
            }
            else
            {
                var cart = _context.Carts.Find(entity);

                if (cart == null)
                {
                    throw new UserException($"'Cart' doesn't exist");
                }
                else
                {
                    cart.CartTotalPrice = cartTotalPrice;
                }
            }

            _context.SaveChanges();

            return cartTotalPrice;
        }
    }
}