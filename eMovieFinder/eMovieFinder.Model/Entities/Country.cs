using eMovieFinder.Model.Utilities;

namespace eMovieFinder.Model.Entities
{
    public class Country : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public string CountryName { get; set; }
    }
}
