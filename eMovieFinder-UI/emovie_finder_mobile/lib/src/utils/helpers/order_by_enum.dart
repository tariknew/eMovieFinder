enum OrderBy {
  lastAddedMovies,
  averageRating,
  rating,
  lastAddedFavouriteMovies,
  moviePrice,
  cartTotalPrice,
  lastAddedOrders
}

extension OrderByExtension on OrderBy {
  String get value {
    switch (this) {
      case OrderBy.lastAddedMovies:
        return "LastAddedMovies";
      case OrderBy.averageRating:
        return "AverageRating";
      case OrderBy.rating:
        return "Rating";
      case OrderBy.lastAddedFavouriteMovies:
        return "LastAddedFavouriteMovies";
      case OrderBy.moviePrice:
        return "Price";
      case OrderBy.cartTotalPrice:
        return "CartTotalPrice";
      case OrderBy.lastAddedOrders:
        return "LastAddedOrders";
    }
  }
}
