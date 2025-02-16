import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/actor/actor_insert_request.dart';
import '../../../models/dtos/requests/actor/actor_update_request.dart';
import '../../../models/entities/actor.dart';
import '../../../models/entities/country.dart';
import '../../../models/searchobjects/actor_search_object.dart';
import '../../../models/utilities/page_result_object.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/order_by_enum.dart';
import '../../../utils/helpers/userexception.dart';
import '../../../utils/providers/base_provider.dart';

class ActorController extends Cubit<BaseState> {
  final BaseProvider<Actor> _baseProvider;

  var actors;

  PageResultObject<Country>? countries;

  ActorController()
      : _baseProvider = BaseProvider<Actor>('/Actor'),
        super(InputWaiting());

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchActors();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else {
        actors = response?.resultList;
      }

      if (actors == null) {
        return null;
      } else {
        emit(ActorLoadedState(actors));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Actors Data"));
    }
  }

  Future<PageResultObject<Actor>?> fetchActors() async {
    try {
      var searchRequest = ActorSearchObject(
          orderBy: OrderBy.lastAddedActors.value, isDescending: true);

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        fromJson: (json) => Actor.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  void sortActorsByCreationDate() {
    List<Actor> actorsList = List<Actor>.from(actors);
    actorsList.sort((a, b) => b.creationDate!.compareTo(a.creationDate!));
    actors = actorsList;
  }

  Future<void> deleteActor(int actorId) async {
    try {
      var response =
      await _baseProvider.delete(id: actorId);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "The actor has been successfully deleted"));

          actors.removeWhere((actor) => actor.id == actorId);

          sortActorsByCreationDate();

          if(actors.isEmpty) {
            emit(EmptyListState());
          } else {
            emit(ActorLoadedState(actors));
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

  Future<void> insertActor(ActorInsertRequest request) async {
      try {
        var response = await _baseProvider.insert(
            request: request, isQueryable: false);

        if (response != null) {
          var data = response.data;

          if (response.statusCode! < 299) {
            emit(ShowSuccessMessageState(
                "Actor has been inserted successfully"));

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

  Future<void> updateActor(int actorId,
      ActorUpdateRequest request) async {
        try {
          var response = await _baseProvider.update(
              id: actorId,
              request: request,
              isSpecificMethod: true
          );

          if (response != null) {
            var data = response.data;

            if (response.statusCode! < 299) {
              emit(ShowSuccessMessageState(
                  "Actor has been updated successfully"));
            } else {
              String errorMessage = UserException.extractExceptionMessage(data);
              emit(ShowErrorMessageState(errorMessage));
            }
          }
        } catch (e) {
          emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
        }
  }

  void actorUpdatedScreenError(){
    emit(ShowErrorMessageState("You must change at least one input field to update the actor"));
  }

  void actorInsertScreenError(){
    emit(ShowErrorMessageState("Please fill in all fields"));
  }

  void actorInsertScreenErrorEmpty(){
    emit(ShowErrorMessageState("Make sure first and last name are not empty"));
  }

  void onDeleteActorPress(String message, int actorId) {
    emit(ShowQuestionMessageState(message, id: actorId));
  }
}

class ActorLoadedState extends BaseState {
  List<Actor>? actors;

  ActorLoadedState(this.actors);
}

