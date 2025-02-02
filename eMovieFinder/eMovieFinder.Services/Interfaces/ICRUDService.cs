using eMovieFinder.Model.SearchObjects;

namespace eMovieFinder.Services.Interfaces
{
    public interface ICRUDService<TModel, TInsert, TUpdate, TSearch> : IReadService<TModel, TSearch>
        where TModel : class where TInsert : class where TUpdate : class where TSearch : BaseSearchObject
    {
        Task<TModel> Insert(TInsert request);
        Task<TModel> Update(int id, TUpdate request);
        Task<IEnumerable<TModel>> Delete(int id);
    }
}