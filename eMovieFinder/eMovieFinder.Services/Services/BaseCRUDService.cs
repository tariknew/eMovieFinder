using eMovieFinder.Database.Context;
using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http;

namespace eMovieFinder.Services.Services
{
    public abstract class BaseCRUDService<TModel, TDbEntity, TInsert, TUpdate, TSearch> : BaseReadService<TModel, TDbEntity, TSearch>
        , ICRUDService<TModel, TInsert, TUpdate, TSearch> where TModel : class where TDbEntity : class where TInsert : class
        where TUpdate : class where TSearch : BaseSearchObject
    {
        protected readonly IHttpContextAccessor _httpContextAccessor;
        public BaseCRUDService(EMFContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
        }
        public virtual async Task<TModel> Insert(TInsert request)
        {
            var set = _context.Set<TDbEntity>();

            TDbEntity entity = _mapper.Map<TDbEntity>(request);

            await BeforeInsert(request, entity);

            var creationDateProperty = typeof(TDbEntity).GetProperty("CreationDate");
            var createdByIdProperty = typeof(TDbEntity).GetProperty("CreatedById");

            if (creationDateProperty != null && creationDateProperty.CanWrite)
            {
                creationDateProperty.SetValue(entity, DateTime.Now);
            }
            if (createdByIdProperty != null && createdByIdProperty.CanWrite)
            {
                var currentIdentityUserId = UserHelper.GetIdentityUserId(_httpContextAccessor);
                createdByIdProperty.SetValue(entity, currentIdentityUserId);
            }

            set.Add(entity);
            _context.SaveChanges();

            var model = _mapper.Map<TModel>(entity);

            AfterInsert(request, entity, model);

            await GetIdentityUserInfoForInsert(model);

            return model;
        }
        public virtual async Task<TModel> Update(int id, TUpdate request)
        {
            var entity = _context.Set<TDbEntity>().Find(id);

            BeforeUpdate(request, entity);

            await BeforeUpdateAsync(request, entity);

            _mapper.Map(request, entity);

            var modifiedDateProperty = typeof(TDbEntity).GetProperty("ModifiedDate");
            var modifiedByIdProperty = typeof(TDbEntity).GetProperty("ModifiedById");

            if (modifiedDateProperty != null && modifiedDateProperty.CanWrite)
            {
                modifiedDateProperty.SetValue(entity, DateTime.Now);
            }
            if (modifiedByIdProperty != null && modifiedByIdProperty.CanWrite)
            {
                var currentIdentityUserId = UserHelper.GetIdentityUserId(_httpContextAccessor);
                modifiedByIdProperty.SetValue(entity, currentIdentityUserId);
            }

            _context.SaveChanges();

            var model = _mapper.Map<TModel>(entity);

            AfterUpdate(request, entity, model);

            return model;
        }
        public virtual async Task<IEnumerable<TModel>> Delete(int id)
        {
            var set = _context.Set<TDbEntity>();
            var entity = set.Find(id);

            BeforeDelete(entity);

            await BeforeDeleteAsync(entity);

            set.Remove(entity);

            _context.SaveChanges();

            return _mapper.Map<List<TModel>>(entity);
        }
        public virtual async Task BeforeInsert(TInsert request, TDbEntity entity)
        {
            await Task.CompletedTask;
        }
        public virtual async Task BeforeUpdateAsync(TUpdate request, TDbEntity entity)
        {
            await Task.CompletedTask;
        }
        public virtual async Task<TModel> GetIdentityUserInfoForInsert(TModel model)
        {
            return await Task.FromResult(model);
        }
        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity) { }
        public virtual void BeforeDelete(TDbEntity entity) { }
        public virtual async Task BeforeDeleteAsync(TDbEntity entity) { }
        public virtual void AfterInsert(TInsert request, TDbEntity entity, TModel model = null) { }
        public virtual void AfterUpdate(TUpdate request, TDbEntity entity, TModel model = null) { }
        public virtual void AfterDelete(TDbEntity entity, TModel model = null) { }
    }
}