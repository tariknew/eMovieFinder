using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.Cart
{
    public class CartInsertRequest
    {
        [Required(ErrorMessage = "UserId is a Required field")]
        public int UserId { get; set; }
        [Required(ErrorMessage = "MovieId is a Required field")]
        public int MovieId { get; set; }
    }
}
