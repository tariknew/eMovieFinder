enum OrderBy {
  lastAddedActors,
  lastAddedCountries,
  lastAddedCategories,
  lastAddedDirectors,
  lastAddedMovies,
  lastAddedUsers,
  lastAddedMovieActors,
  lastAddedFavouriteMovies
}

extension OrderByExtension on OrderBy {
  String get value {
    switch (this) {
      case OrderBy.lastAddedActors:
        return "LastAddedActors";
      case OrderBy.lastAddedCountries:
        return "LastAddedCountries";
      case OrderBy.lastAddedCategories:
        return "LastAddedCategories";
      case OrderBy.lastAddedDirectors:
        return "LastAddedDirectors";
      case OrderBy.lastAddedMovies:
        return "LastAddedMovies";
      case OrderBy.lastAddedUsers:
        return "LastAddedUsers";
      case OrderBy.lastAddedMovieActors:
        return "LastAddedMovieActors";
      case OrderBy.lastAddedFavouriteMovies:
        return "LastAddedFavouriteMovies";
    }
  }
}
