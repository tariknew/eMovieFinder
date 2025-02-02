using eMovieFinder.Model.Utilities;

namespace eMovieFinder.Model.Entities
{
    public class MovieActor : TimeStampObjectViewModel
    {
        public int Id { get; set; }
        public int MovieId { get; set; }
        public int ActorId { get; set; }
        public string? CharacterName { get; set; }
        public virtual Actor Actor { get; set; }
        public string? MovieTitle { get; set; }
    }
}
