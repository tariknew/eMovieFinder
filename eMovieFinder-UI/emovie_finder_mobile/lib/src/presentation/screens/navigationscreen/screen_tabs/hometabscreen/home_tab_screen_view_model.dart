import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/entities/moviefavourite.dart';
import '../../../../../models/searchobjects/movie_favourite_search_object.dart';
import '../../../../../models/utilities/page_result_object.dart';
import '../../../../../models/searchobjects/movie_search_object.dart';
import '../../../../../models/entities/movie.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/order_by_enum.dart';
import '../../../../../utils/providers/app_config_provider.dart';
import '../../../../../utils/providers/base_provider.dart';
import '../../navigation_screen_view_model.dart';

class HomeTabScreenViewModel extends Cubit<BaseState> {
  final BaseProvider _baseProvider = BaseProvider();

  HomeTabScreenViewModel() : super(LoadingState());

  var actionMovies;
  var crimeMovies;
  var comedyMovies;
  var recommendMovieItems;

  AppConfigProvider? provider;

  NavigationScreenViewModel? homeScreenViewModel;

  Future<dynamic> fetchData({bool isRefreshing = false}) async {
    emit(isRefreshing ? RefreshState() : LoadingState());
    try {
      final response = await Future.wait([fetchMovies(), getFavouriteMovies()]);

      actionMovies = response[0]
          ?.resultList
          .where((movie) =>
              movie.movieCategories
                  ?.any((category) => category.categoryId == 1) ??
              false)
          .toList();

      crimeMovies = response[0]
          ?.resultList
          .where((movie) =>
              movie.movieCategories
                  ?.any((category) => category.categoryId == 2) ??
              false)
          .toList();

      comedyMovies = response[0]
          ?.resultList
          .where((movie) =>
              movie.movieCategories
                  ?.any((category) => category.categoryId == 3) ??
              false)
          .toList();

      if (response[1]!.count! > 0) {
        final favouriteMovieIds = (response[1]?.resultList as List)
            .map((item) => item.movieId as int)
            .toList();

        recommendMovieItems = await getRecommendMovieItems(favouriteMovieIds);
      } else {
        recommendMovieItems = [];
      }

      if (actionMovies == null &&
          crimeMovies == null &&
          comedyMovies == null &&
          recommendMovieItems == null) {
        return null;
      } else {
        emit(MoviesLoadedState(
            actionMovies, crimeMovies, comedyMovies, recommendMovieItems));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Movie Data"));
    }
  }

  Future<PageResultObject<dynamic>?> fetchMovies() async {
    try {
      String query = '/Movie';

      var searchRequest = MovieSearchObject(
          isMovieCategoriesIncluded: true,
          isAdministratorPanel: false,
          orderBy: OrderBy.lastAddedMovies.value,
          isDescending: true);

      var response = await _baseProvider.get(
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

  Future<PageResultObject<dynamic>?> getFavouriteMovies() async {
    try {
      var userId = await AppConfigProvider().getValueFromStorage("userId");

      String query = '/MovieFavourite';

      var searchRequest = MovieFavouriteSearchObject(userId: int.parse(userId));

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        query: query,
        fromJson: (json) => MovieFavourite.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<List<dynamic>?> getRecommendMovieItems(
      List<int> favouriteMovieIds) async {
    try {
      String query = '/Recommender/RecommendMovieItems?';

      query +=
          favouriteMovieIds.map((id) => 'favouriteMoviesIds=$id').join('&');

      var response = await _baseProvider.getRecommendMovieItems(
        query: query,
        fromJson: (json) => Movie.fromJson(json),
      );

      if(response == null) {
        return [];
      } else {
        return response;
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  void setStateToLoading() {
    emit(LoadingState());
  }

  void goToDetailsScreen(num movie) {
    emit(MovieDetailsAction(movie));
  }
}

class RefreshState extends BaseState {}

class MoviesLoadedState extends BaseState {
  List<dynamic>? actionMovies;
  List<dynamic>? crimeMovies;
  List<dynamic>? comedyMovies;
  List<dynamic>? recommendMovieItems;

  MoviesLoadedState(this.actionMovies, this.crimeMovies, this.comedyMovies,
      this.recommendMovieItems);
}
