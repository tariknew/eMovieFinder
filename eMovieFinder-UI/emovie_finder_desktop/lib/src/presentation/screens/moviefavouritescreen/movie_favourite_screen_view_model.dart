import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/movie/movie_favourite_insert_request.dart';
import '../../../models/entities/movie.dart';
import '../../../models/entities/moviefavourite.dart';
import '../../../models/entities/user.dart';
import '../../../models/searchobjects/movie_favourite_search_object.dart';
import '../../../models/utilities/page_result_object.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/order_by_enum.dart';
import '../../../utils/helpers/userexception.dart';
import '../../../utils/providers/base_provider.dart';

class MovieFavouriteController extends Cubit<BaseState> {
  final BaseProvider<MovieFavourite> _baseProvider;

  MovieFavouriteController()
      : _baseProvider = BaseProvider<MovieFavourite>('/MovieFavourite'),
        super(InputWaiting());

  var movieFavourites;

  PageResultObject<Movie>? movies;
  PageResultObject<User>? users;

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchMovieFavourites();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else {
        movieFavourites = response?.resultList;
      }

      if (movieFavourites == null) {
        return null;
      } else {
        emit(MovieFavouriteLoadedState(movieFavourites));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Movie Favourites Data"));
    }
  }

  Future<PageResultObject<MovieFavourite>?> fetchMovieFavourites() async {
    try {
      var searchRequest = MovieFavouriteSearchObject(
          isUserIncluded: true,
          isMovieIncluded: true,
          orderBy: OrderBy.lastAddedFavouriteMovies.value,
          isDescending: true
      );

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        fromJson: (json) => MovieFavourite.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<void> insertMovieFavourite(MovieFavouriteInsertRequest request) async {
    try {
      var response =
      await _baseProvider.insert(request: request, isQueryable: false);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "Movie has been successfully inserted in favourites"));

          fetchData();
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  void movieFavouriteInsertScreenError() {
    emit(ShowErrorMessageState("Please fill in all fields"));
  }
}

class MovieFavouriteLoadedState extends BaseState {
  List<MovieFavourite>? movieFavourites;

  MovieFavouriteLoadedState(this.movieFavourites);
}
