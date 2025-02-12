using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace eMovieFinder.Model.Dtos.Requests.Movie
{
    public class MovieUpdateRequest
    {
        public string? Title { get; set; }
        public DateTime? ReleaseDate { get; set; }
        public int? Duration { get; set; }
        public int? DirectorId { get; set; }
        public List<int>? Categories { get; set; }
        public List<int>? Actors { get; set; }
        public int? CountryId { get; set; }
        public string? TrailerLink { get; set; }
        public string? ImagePlainText { get; set; }
        [DefaultValue(null)]
        public byte[]? Image { get; set; }
        public string? StoryLine { get; set; }
        public double? Price { get; set; }
        public double? AverageRating { get; set; }
        public int? MovieState { get; set; }
        public decimal? Discount { get; set; }
    }
}
