using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.MovieActor
{
    public class MovieActorInsertRequest
    {
        [Required(ErrorMessage = "MovieId is a Required field")]
        public int MovieId { get; set; }
        [Required(ErrorMessage = "ActorId is a Required field")]
        public int ActorId { get; set; }
        [Required(ErrorMessage = "CharacterName is a Required field")]
        public string? CharacterName { get; set; }
    }
}
