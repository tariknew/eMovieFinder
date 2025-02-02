using eMovieFinder.Model.Utilities;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eMovieFinder.Database.Entities
{
    public class MovieActor : TimeStampObject
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey("Movie")]
        public int MovieId { get; set; }
        public virtual Movie Movie { get; set; }

        [ForeignKey("Actor")]
        public int ActorId { get; set; }
        public virtual Actor Actor { get; set; }
        public string? CharacterName { get; set; }
    }
}
