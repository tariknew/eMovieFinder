namespace eMovieFinder.Model.Dtos.Requests.Order
{
    public class OrderSalesReportInsertRequest
    {
        public int MovieId { get; set; }
        public int? Year { get; set; }
        public int? Month { get; set; }
    }
}
