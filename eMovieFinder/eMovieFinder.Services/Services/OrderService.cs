using eMovieFinder.Database.Context;
using eMovieFinder.Database.Entities;
using eMovieFinder.Model.Dtos.Requests.Order;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace eMovieFinder.Services.Services
{
    public class OrderService : BaseCRUDService<Model.Entities.Order, Order, object, object, OrderSearchObject>
    , IOrderService
    {
        public OrderService(EMFContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper, httpContextAccessor) { }
        public override IQueryable<Order> AddFilter(OrderSearchObject search, IQueryable<Order> query)
        {
            if (search?.UserId != null && search?.UserId != 0)
            {
                query = query.Where(x => x.User.Id == search.UserId);
            }

            query = ApplyInclude(search, query);

            if (search?.OrderBy != null)
            {
                switch (search.OrderBy)
                {
                    case "LastAddedOrders":
                        query = SortBy(query, m => m.OrderDate.Date,
                        search.IsDescending.Value); break;
                }
            }

            return query;
        }
        public override async Task<Model.Entities.Order> Insert(object request)
        {
            throw new UserException("Method isn't implemented");
        }
        public override async Task<Model.Entities.Order> Update(int id, object request)
        {
            throw new UserException("Method isn't implemented");
        }
        public override async Task<IEnumerable<Model.Entities.Order>> Delete(int id)
        {
            throw new UserException("Method isn't implemented");
        }
        public override async Task<Model.Entities.Order> GetById(int id, OrderSearchObject search = null)
        {
            throw new UserException("Method isn't implemented");
        }
        private IQueryable<Order> ApplyInclude(OrderSearchObject search, IQueryable<Order> query)
        {
            if (search.IsUserIncluded == true)
            {
                query = query.Include(x => x.User);
            }
            if (search.IsOrderMovieIncluded == true)
            {
                query = query.Include(x => x.OrderMovies)
                    .ThenInclude(x => x.Movie);
            }

            return query;
        }
        public async Task<Model.Entities.OrderSalesReport> GetOrderSalesReport(OrderSalesReportInsertRequest request)
        {
            var query = _context.OrderMovies
                .Include(om => om.Movie)
                .Include(om => om.Order)
                .Where(om => om.MovieId == request.MovieId)
                .AsQueryable();

            if (request.Year.HasValue)
                query = query.Where(om => om.Order.OrderDate.Year == request.Year.Value);

            if (request.Month.HasValue)
                query = query.Where(om => om.Order.OrderDate.Month == request.Month.Value);

            var totalOrders = await query.CountAsync();

            return new Model.Entities.OrderSalesReport
            {
                TotalOrders = totalOrders
            };
        }
    }
}