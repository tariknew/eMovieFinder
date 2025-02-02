using eMovieFinder.Model.Entities;
using eMovieFinder.Services.Interfaces.ML;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eMovieFinder.API.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    public class RecommenderController : ControllerBase
    {
        private readonly IRecommenderTrainService _recommenderTrainService;
        private readonly IRecommenderPredictService _recommenderPredictService;
        public RecommenderController(IRecommenderTrainService recommenderTrainService,
            IRecommenderPredictService recommenderPredictService)
        {
            _recommenderTrainService = recommenderTrainService;
            _recommenderPredictService = recommenderPredictService;
        }
        [HttpPost]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator")]
        public IActionResult TrainFavouriteMoviesModel()
        {
            _recommenderTrainService.TrainFavouriteMoviesModel();
            return Ok();
        }
        [HttpGet]
        [Authorize(AuthenticationSchemes = "Bearer", Roles = "Administrator,User,Customer")]
        public List<Movie> RecommendMovieItems([FromQuery] List<int> favouriteMoviesIds)
        {
            return _recommenderPredictService.RecommendMovieItems(favouriteMoviesIds);
        }
    }
}