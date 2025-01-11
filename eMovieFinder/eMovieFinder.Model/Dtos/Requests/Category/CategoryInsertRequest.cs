using System.ComponentModel.DataAnnotations;

namespace eMovieFinder.Model.Dtos.Requests.Category
{
    public class CategoryInsertRequest
    {
        [Required(ErrorMessage = "CategoryName is a Required field")]
        public string CategoryName { get; set; }
    }
}
