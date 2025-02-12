using eMovieFinder.Model.Dtos.Requests.MovieReview;
using eMovieFinder.Model.SearchObjects;
using eMovieFinder.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    public class MovieReviewController : BaseCRUDController<Model.Entities.MovieReview, Database.Entities.MovieReview, MovieReviewInsertRequest, MovieReviewUpdateRequest, MovieReviewSearchObject>
    {
        public MovieReviewController(IMovieReviewService service) : base(service) { }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator, Customer")]
        public override async Task<Model.Entities.MovieReview> Insert([FromBody] MovieReviewInsertRequest request)
        {
            var result = await base.Insert(request);

            return result;
        }
        [HttpPut("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public override async Task<Model.Entities.MovieReview> Update(int id, [FromBody] MovieReviewUpdateRequest request)
        {
            var result = await base.Update(id, request);

            return result;
        }
        [HttpDelete("{id}")]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator, Customer")]
        public override async Task<IEnumerable<Model.Entities.MovieReview>> Delete(int id)
        {
            var result = await base.Delete(id);

            return result;
        }
    }
}