using System.Collections.Generic;

namespace eMovieFinder.Model.Utilities
{
    public class PageResultObject<TModel>
    {
        public int? Count { get; set; }
        public IEnumerable<TModel> ResultList { get; set; }
    }
}