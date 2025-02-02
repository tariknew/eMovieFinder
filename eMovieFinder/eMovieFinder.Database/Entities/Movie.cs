using eMovieFinder.Helpers.Utilities;
using eMovieFinder.Model.Utilities;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eMovieFinder.Database.Entities
{
    public class Movie : TimeStampObject
    {
        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        public DateTime ReleaseDate { get; set; }
        public int Duration { get; set; }
        [ForeignKey("Director")]
        public int? DirectorId { get; set; }
        public virtual Director Director { get; set; }
        [ForeignKey("Country")]
        public int? CountryId { get; set; }
        public virtual Country Country { get; set; }
        public string TrailerLink { get; set; }
        public byte[]? Image { get; set; }
        public string StoryLine { get; set; }
        public double Price { get; set; }
        public decimal? Discount { get; set; }
        public double? AverageRating { get; set; }
        public MovieStatesEnumeration.MovieStatesEnum? MovieState { get; set; }
        public virtual ICollection<MovieCategory> MovieCategories { get; set; }
        public virtual ICollection<MovieReview> MovieReviews { get; set; }
        public virtual ICollection<MovieActor> MovieActors { get; set; }
    }
}
