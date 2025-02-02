using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.Cart
{
    public class CartDeleteRequest
    {
        [Required(ErrorMessage = "CartId is a Required field")]
        public int CartId { get; set; }
        [Required(ErrorMessage = "MovieId is a Required field")]
        public int MovieId { get; set; }
    }
}
