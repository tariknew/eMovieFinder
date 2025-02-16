import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/movie/movie_insert_request.dart';
import '../../../models/dtos/requests/movie/movie_update_request.dart';
import '../../../models/entities/actor.dart';
import '../../../models/entities/country.dart';
import '../../../models/entities/director.dart';
import '../../../models/entities/movie.dart';
import '../../../models/entities/category.dart';
import '../../../models/searchobjects/movie_search_object.dart';
import '../../../models/utilities/page_result_object.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/userexception.dart';
import '../../../utils/providers/base_provider.dart';

class MovieController extends Cubit<BaseState> {
  final BaseProvider<Movie> _baseProvider;

  MovieController()
      : _baseProvider = BaseProvider<Movie>('/Movie'),
        super(InputWaiting());

  var movies;

  PageResultObject<Category>? categories;
  PageResultObject<Actor>? actors;
  PageResultObject<Director>? directors;
  PageResultObject<Country>? countries;

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchMovies();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else {
        movies = response?.resultList;
      }

      if (movies == null) {
        return null;
      } else {
        emit(MovieLoadedState(movies));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Movies Data"));
    }
  }

  Future<PageResultObject<Movie>?> fetchMovies() async {
    try {
      var searchRequest = MovieSearchObject(
          isDirectorIncluded: true,
          isCountryIncluded: true,
          isMovieReviewsIncluded: true,
          isMovieCategoriesIncluded: true,
          isMovieActorsIncluded: true,
          isAdministratorPanel: true,
      );

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        fromJson: (json) => Movie.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<void> insertMovie(MovieInsertRequest request) async {
    try {
      var response = await _baseProvider.insert(
          request: request, isQueryable: false);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "Movie has been inserted successfully, we are redicting you to page to add actors character names"));

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

  Future<void> updateMovie(int movieId,
      MovieUpdateRequest request) async {
    try {
      var response = await _baseProvider.update(
          id: movieId,
          request: request,
          isSpecificMethod: true
      );

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "Movie has been updated successfully"));
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  Future<void> deleteMovie(int movieId) async {
    try {
      var response =
      await _baseProvider.delete(id: movieId);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "The Movie has been successfully deleted"));

          movies.removeWhere((movie) => movie.id == movieId);

          sortMoviesByCreationDate();

          if(movies.isEmpty) {
            emit(EmptyListState());
          } else {
            emit(MovieLoadedState(movies));
          }
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  void sortMoviesByCreationDate() {
    List<Movie> moviesList = List<Movie>.from(movies);
    moviesList.sort((a, b) => b.creationDate!.compareTo(a.creationDate!));
    movies = moviesList;
  }

  void movieInsertScreenError(){
    emit(ShowErrorMessageState("Please fill in all fields"));
  }

  void movieUpdatedScreenError(){
    emit(ShowErrorMessageState("You must change at least one input field to update the movie"));
  }

  void onDeleteMoviePress(String message, int movieId) {
    emit(ShowQuestionMessageState(message, id: movieId));
  }
}

class MovieLoadedState extends BaseState {
  List<Movie>? movies;

  MovieLoadedState(this.movies);
}

