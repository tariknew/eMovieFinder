using Microsoft.ML.Data;

namespace eMovieFinder.Model.ML
{
    public class CopurchasePrediction
    {
        public float Score { get; set; }
    }
    public class ProductEntry
    {
        [KeyType(count: 100)]
        public uint ProductId { get; set; }
        [KeyType(count: 100)]
        public uint CoPurchaseProductId { get; set; }
        public float Label { get; set; }
    }
}
