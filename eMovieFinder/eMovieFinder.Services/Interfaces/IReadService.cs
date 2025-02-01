using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Model.Utilities;

namespace eMovieFinder.Services.Interfaces
{
    public interface IReadService<TModel, TSearch> where TModel : class where TSearch : BaseSearchObject
    {
        Task<PageResultObject<TModel>> Get(TSearch search = null);
        Task<TModel> GetById(int id, TSearch search = null);
    }
}