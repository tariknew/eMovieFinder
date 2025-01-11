using eMovieFinder.Model.Dtos.Requests.Cart;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface ICartService : ICRUDService<Cart, CartInsertRequest, object, CartSearchObject>
    {
        IEnumerable<Cart> DeleteMovieFromCart(CartDeleteRequest request);
        Task DeleteAllFromCart(int userId);
    }
}