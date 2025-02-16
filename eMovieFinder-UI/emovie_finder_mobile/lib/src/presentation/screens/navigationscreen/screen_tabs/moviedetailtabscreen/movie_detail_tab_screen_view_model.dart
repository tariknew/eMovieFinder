import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/dtos/requests/cart/cart_delete_request.dart';
import '../../../../../models/dtos/requests/cart/cart_insert_request.dart';
import '../../../../../models/dtos/requests/moviefavourite/movie_favourite_insert_request.dart';
import '../../../../../models/dtos/requests/moviereview/movie_review_insert_request.dart';
import '../../../../../models/entities/cart.dart';
import '../../../../../models/searchobjects/cart_search_object.dart';
import '../../../../../models/searchobjects/movie_favourite_search_object.dart';
import '../../../../../models/searchobjects/movie_search_object.dart';
import '../../../../../models/entities/movie.dart';
import '../../../../../models/entities/moviefavourite.dart';
import '../../../../../models/entities/moviereview.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/userexception.dart';
import '../../../../../utils/providers/app_config_provider.dart';
import '../../../../../utils/providers/base_provider.dart';
import '../../navigation_screen_view_model.dart';

class MovieDetailTabScreenViewModel extends Cubit<BaseState> {
  final BaseProvider _baseProvider = BaseProvider();

  MovieDetailTabScreenViewModel() : super(LoadingState());

  AppConfigProvider? provider;

  var movieData;
  var movieReviews;

  final TextEditingController commentController = TextEditingController();

  int movieFavouriteId = 0;

  bool userHasSubmittedReview = false;
  bool isMovieFavourite = false;
  bool isMovieInCart = false;

  String userRating = '0';
  String averageRating = '';
  int cartId = 0;

  NavigationScreenViewModel? homeScreenViewModel;

  Future<dynamic> loadMovieData(num movieId) async {
    try {
      var userId = await AppConfigProvider().getValueFromStorage("userId");

      final response = await getMovieById(movieId);

      movieData = response;
      movieReviews = response?.movieReviews;

      bool userHasReview =
          movieReviews?.any((review) => review.userId == int.parse(userId)) ??
              false;

      averageRating = movieData.formattedAverageRating;
      userHasSubmittedReview = userHasReview;

      if (movieData == null && movieReviews == null) {
        return null;
      } else {
        sortMovieReviews();

        emit(DataLoadedState(movieData, movieReviews));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Movie Data"));
    }
  }

  void sortMovieReviews() {
    List<MovieReview> reviews = List<MovieReview>.from(movieReviews);
    reviews.sort((a, b) => b.rating!.compareTo(a.rating as num));
    movieReviews = reviews;
  }

  Future<Movie?> getMovieById(num movieId) async {
    try {
      String query = '/Movie';

      var searchRequest = MovieSearchObject(
          isDirectorIncluded: true,
          isCountryIncluded: true,
          isMovieReviewsIncluded: true,
          isMovieCategoriesIncluded: true,
          isMovieActorsIncluded: true);

      var response = await _baseProvider.getById(
        id: movieId as int,
        searchRequest: searchRequest,
        query: query,
        fromJson: (json) => Movie.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<void> insertReview(MovieReviewInsertRequest request) async {
    if (validateForm()) {
      emit(ShowLoadingState("Inserting Your Review"));
      try {
        String query = '/MovieReview';

        var response = await _baseProvider.insert(
            request: request, query: query, isQueryable: false);

        if (response != null) {
          var data = response.data;

          if (response.statusCode! < 299) {
            emit(HideDialog());
            emit(ShowSuccessMessageState(
                "Review has been created successfully"));

            MovieReview newReview = MovieReview.fromJson(data);
            movieReviews.add(newReview);

            sortMovieReviews();

            emit(DataLoadedState(movieData, movieReviews));

            averageRating = newReview.formattedAverageRating!;
            userHasSubmittedReview = true;
          } else {
            String errorMessage = UserException.extractExceptionMessage(data);
            emit(HideDialog());
            emit(ShowErrorMessageState(errorMessage));
          }
        }
      } catch (e) {
        emit(HideDialog());
        emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      }
    }
  }

  Future<void> addMovieToCart(int movieId) async {
    try {
      String query = '/Cart';

      var userId = await AppConfigProvider().getValueFromStorage("userId");

      var insertRequest = CartInsertRequest(
        userId: int.parse(userId),
        movieId: movieId,
      );

      var response = await _baseProvider.insert(
          request: insertRequest, query: query, isQueryable: false);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "Movie has been successfully added to the cart"));

          emit(DataLoadedState(movieData, movieReviews));

          Cart newCart = Cart.fromJson(data);
          cartId = newCart.id!;

          isMovieInCart = true;
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  Future<void> removeMovieFromCart(int movieId) async {
    try {
      var deleteRequest = CartDeleteRequest(
        cartId: cartId,
        movieId: movieId,
      );

      String query = '/Cart/DeleteMovieFromCart'
          '?CartId=${deleteRequest.cartId}&MovieId=${deleteRequest.movieId}';

      var response =
          await _baseProvider.update(query: query, isSpecificMethod: true);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "The movie has been successfully removed from the cart"));

          emit(DataLoadedState(movieData, movieReviews));

          isMovieInCart = false;
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  Future<bool?> isMovieAddedToCart(int movieId) async {
    try {
      String query = '/Cart';

      var userId = await AppConfigProvider().getValueFromStorage("userId");

      var searchRequest = CartSearchObject(
        userId: int.parse(userId),
        movieId: movieId,
      );

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        query: query,
        fromJson: (json) => Cart.fromJson(json),
      );

      if (response != null && response.resultList.isNotEmpty) {
        var firstObject = response.resultList.first;
        cartId = firstObject.id;

        return isMovieInCart = true;
      } else {
        return isMovieInCart = false;
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return false;
    }
  }

  Future<int?> isMovieInFavourites(int movieId) async {
    try {
      String query = '/MovieFavourite';

      var userId = await AppConfigProvider().getValueFromStorage("userId");

      var searchRequest = MovieFavouriteSearchObject(
        movieId: movieId,
        userId: int.parse(userId),
      );

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        query: query,
        fromJson: (json) => MovieFavourite.fromJson(json),
      );

      if (response != null && response.resultList.isNotEmpty) {
        isMovieFavourite = true;

        var firstObject = response.resultList[0];
        movieFavouriteId = firstObject.id;

        return movieFavouriteId;
      } else {
        isMovieFavourite = false;

        return null;
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<void> addOrRemoveFavouriteMovie(int movieId) async {
    if (!isMovieFavourite) {
      try {
        String query = '/MovieFavourite';

        var userId = await AppConfigProvider().getValueFromStorage("userId");

        var insertRequest = MovieFavouriteInsertRequest(
            userId: int.parse(userId), movieId: movieId);

        var response = await _baseProvider.insert(
            request: insertRequest, query: query, isQueryable: false);

        if (response != null) {
          var data = response.data;

          if (response.statusCode! < 299) {
            emit(ShowSuccessMessageState(
                "The movie has been successfully added to favourites"));

            MovieFavourite newMovieFavourite = MovieFavourite.fromJson(data);

            emit(DataLoadedState(movieData, movieReviews));

            movieFavouriteId = newMovieFavourite.id!;
            isMovieFavourite = true;
          } else {
            String errorMessage = UserException.extractExceptionMessage(data);
            emit(ShowErrorMessageState(errorMessage));
          }
        }
      } catch (e) {
        emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      }
    } else {
      removeFavouriteMovie(movieFavouriteId);
    }
  }

  Future<void> removeFavouriteMovie(int movieFavouriteId) async {
    try {
      String query = '/MovieFavourite';

      var response =
          await _baseProvider.delete(id: movieFavouriteId, query: query);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "The movie has been successfully removed from favourites"));

          emit(DataLoadedState(movieData, movieReviews));

          isMovieFavourite = false;
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  Future<void> deleteReview(num movieReviewId) async {
    emit(ShowLoadingState("Deleting Your Review"));
    try {
      String query = '/MovieReview';

      var response =
          await _baseProvider.delete(id: movieReviewId as int, query: query);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(HideDialog());
          emit(ShowSuccessMessageState("Review has been deleted successfully"));

          var reviewData = data[0];
          averageRating = reviewData['formattedAverageRating'];

          movieReviews.removeWhere((review) => review.id == movieReviewId);

          sortMovieReviews();

          emit(DataLoadedState(movieData, movieReviews));

          userHasSubmittedReview = false;
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(HideDialog());
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(HideDialog());
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  bool validateForm() {
    final comment = commentController.text.trim();
    final rating = userRating;

    if (comment.isEmpty || rating.isEmpty || rating == '0') {
      emit(ShowErrorMessageState("Please fill in all fields"));
      return false;
    }

    if (comment.length > 15) {
      emit(ShowErrorMessageState("Comment can't exceed 15 characters"));
      return false;
    }

    if (double.parse(rating) > 5) {
      emit(
          ShowErrorMessageState("The rating can't be greater than five stars"));
      return false;
    }

    return true;
  }

  clearFields() {
    commentController.clear();
    updateUserRating(0);
  }

  void setStateToLoading() {
    emit(LoadingState());
  }

  void onPressBackAction() {
    emit(BackAction());
  }

  void goToDetailsScreen(num movie) {
    emit(MovieDetailsAction(movie));
  }

  void onDeleteReviewPress(String message, int movieReviewId) {
    emit(ShowQuestionMessageState(message, id: movieReviewId));
  }

  void onAddOrRemoveMovieFromCartPress(String message) {
    emit(ShowQuestionMessageState(message));
  }

  void onAddOrRemoveMovieFromFavouritesPress(String message) {
    emit(ShowQuestionMessageState(message));
  }

  void updateUserRating(double rate) {
    userRating = rate.toString();
    emit(RatingUpdatedState(userRating));
  }
}

class DataLoadedState extends BaseState {
  Movie movie;
  List<MovieReview>? movieReviews;

  DataLoadedState(this.movie, this.movieReviews);
}

class RatingUpdatedState extends BaseState {
  final String userRating;

  RatingUpdatedState(this.userRating);
}

class BackAction extends BaseState {}
