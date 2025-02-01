using eMovieFinder.Model.Dtos.Requests.Cart;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class CartController : BaseCRUDController<Model.Entities.Cart, Database.Entities.Cart, CartInsertRequest, object, CartSearchObject>
    {
        public CartController(ICartService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public override async Task<Model.Entities.Cart> Insert([FromBody] CartInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Cart> Update(int id, [FromBody] object request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public override async Task<IEnumerable<Model.Entities.Cart>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
        [HttpDelete]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public Task DeleteAllFromCart(int userId)
        {
            return (_crudService as ICartService).DeleteAllFromCart(userId);
        }
        [HttpPut]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public IEnumerable<Model.Entities.Cart> DeleteMovieFromCart([FromQuery] CartDeleteRequest request)
        {
            return (_crudService as ICartService).DeleteMovieFromCart(request);
        }
    }
}