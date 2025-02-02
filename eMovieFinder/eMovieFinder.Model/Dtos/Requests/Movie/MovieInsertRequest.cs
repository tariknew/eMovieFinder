using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.Movie
{
    public class MovieInsertRequest
    {
        [Required(ErrorMessage = "Movie Title is a Required field")]
        public string Title { get; set; }
        [Required(ErrorMessage = "Release Date is a Required field")]
        public DateTime ReleaseDate { get; set; }
        [Required(ErrorMessage = "Duration is a Required field")]
        public int Duration { get; set; }
        [Required(ErrorMessage = "DirectorId is a Required field")]
        public int DirectorId { get; set; }
        [Required(ErrorMessage = "Categories is a Required field")]
        public List<int> Categories { get; set; }
        [Required(ErrorMessage = "Actors is a Required field")]
        public List<int> Actors { get; set; }
        [Required(ErrorMessage = "CountryId is a Required field")]
        public int CountryId { get; set; }
        [Required(ErrorMessage = "TrailerLink is a Required field")]
        public string TrailerLink { get; set; }
        [Required(ErrorMessage = "ImagePlainText is a Required field")]
        public string? ImagePlainText { get; set; }
        [DefaultValue(null)]
        public byte[]? Image { get; set; }
        [Required(ErrorMessage = "StoryLine is a Required field")]
        public string StoryLine { get; set; }
        [Required(ErrorMessage = "Price is a Required field")]
        public double Price { get; set; }
        [Required(ErrorMessage = "MovieState is a Required field")]
        public int MovieState { get; set; }
        [Required(ErrorMessage = "Discount is a Required field")]
        public decimal Discount { get; set; }
    }
}
