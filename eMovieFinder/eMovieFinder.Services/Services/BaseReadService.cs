using eMovieFinder.Database.Context;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using System.Linq.Expressions;

namespace eMovieFinder.Services.Services
{
    public abstract class BaseReadService<TModel, TDbEntity, TSearch> : IReadService<TModel, TSearch> where TModel : class where TDbEntity : class where TSearch : BaseSearchObject
    {
        protected readonly EMFContext _context;
        protected readonly IMapper _mapper;
        public BaseReadService(EMFContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public virtual async Task<PageResultObject<TModel>> Get(TSearch search = null)
        {
            var query = _context.Set<TDbEntity>().AsQueryable();

            query = AddFilter(search, query);

            int count = query.Count();

            if (search?.PageNumber.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip(search.PageNumber.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var result = _mapper.Map<List<TModel>>(query.ToList());

            await FillTheModel(result);

            PageResultObject<TModel> pagedResult = new PageResultObject<TModel>
            {
                ResultList = result,
                Count = count
            };

            return pagedResult;
        }
        public virtual async Task<TModel> GetById(int id, TSearch search = null)
        {
            var entity = _context.Set<TDbEntity>().Find(id);

            BeforeGetById(entity);

            return _mapper.Map<TModel>(entity);
        }
        public virtual async Task<TModel> GetIdentityUserInfoForGet(TModel model)
        {
            return await Task.FromResult(model);
        }
        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }
        public virtual async Task<List<TModel>> FillTheModel(List<TModel> model)
        {
            return model;
        }
        public virtual void BeforeGetById(TDbEntity entity) { }
        public virtual IQueryable<TDbEntity> SortBy(IQueryable<TDbEntity> query,
            Expression<Func<TDbEntity, object>> sortByProperty, bool isDescending)
        {
            if (isDescending)
                return query.OrderByDescending(sortByProperty);
            else
                return query.OrderBy(sortByProperty);
        }
    }
}