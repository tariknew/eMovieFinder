using eMovieFinder.Model.Dtos.Requests.Order;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class OrderController : BaseCRUDController<Model.Entities.Order, Database.Entities.Order, object, object, OrderSearchObject>
    {
        public OrderController(IOrderService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public override async Task<Model.Entities.Order> Insert([FromBody] object request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.Order> Update(int id, [FromBody] object request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public override async Task<IEnumerable<Model.Entities.Order>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
        [HttpGet]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public async Task<Model.Entities.OrderSalesReport> GetOrderSalesReport([FromQuery] OrderSalesReportInsertRequest request)
        {
            var result = await (_crudService as IOrderService).GetOrderSalesReport(request);

            return result;
        }
    }
}