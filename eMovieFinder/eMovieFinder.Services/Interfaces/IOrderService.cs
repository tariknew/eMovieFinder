using eMovieFinder.Model.Dtos.Requests.Order;
using eMovieFinder.Model.Entities;
using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface IOrderService : ICRUDService<Order, object, object, OrderSearchObject>
    {
        Task<OrderSalesReport> GetOrderSalesReport(OrderSalesReportInsertRequest request);
    }
}
