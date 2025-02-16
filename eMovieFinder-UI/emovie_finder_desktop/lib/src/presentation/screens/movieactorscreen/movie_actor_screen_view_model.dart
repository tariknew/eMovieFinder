import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/movie/movie_actor_update_request.dart';
import '../../../models/entities/movieactor.dart';
import '../../../models/searchobjects/movie_actor_search_object.dart';
import '../../../models/utilities/page_result_object.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/order_by_enum.dart';
import '../../../utils/helpers/userexception.dart';
import '../../../utils/providers/base_provider.dart';

class MovieActorController extends Cubit<BaseState> {
  final BaseProvider<MovieActor> _baseProvider;

  MovieActorController()
      : _baseProvider = BaseProvider<MovieActor>('/MovieActor'),
        super(InputWaiting());

  var movieActors;

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchMovieActors();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else {
        movieActors = response?.resultList;
      }

      if (movieActors == null) {
        return null;
      } else {
        emit(MovieActorLoadedState(movieActors));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Movie Actors Data"));
    }
  }

  Future<PageResultObject<MovieActor>?> fetchMovieActors() async {
    try {
      var searchRequest = MovieActorSearchObject(
          isActorIncluded: true,
          orderBy: OrderBy.lastAddedMovieActors.value,
          isDescending: true
      );

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        fromJson: (json) => MovieActor.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<void> updateMovieActor(
      int movieActorId, MovieActorUpdateRequest request) async {
    try {
      var response = await _baseProvider.update(
          id: movieActorId, request: request, isSpecificMethod: true);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(
              ShowSuccessMessageState("Movie actor has been updated successfully"));
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  void movieActorUpdatedScreenError(String message) {
    emit(ShowErrorMessageState(message));
  }
}

class MovieActorLoadedState extends BaseState {
  List<MovieActor>? movieActors;

  MovieActorLoadedState(this.movieActors);
}
