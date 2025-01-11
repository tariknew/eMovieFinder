namespace eMovieFinder.Model.Dtos.Requests.MovieActor
{
    public class MovieActorUpdateRequest
    {
        public int? MovieId { get; set; }
        public int? ActorId { get; set; }
        public string? CharacterName { get; set; }
    }
}
