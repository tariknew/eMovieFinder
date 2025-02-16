import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/director/director_insert_request.dart';
import '../../../models/dtos/requests/director/director_update_request.dart';
import '../../../models/entities/director.dart';
import '../../../models/searchobjects/director_search_object.dart';
import '../../../models/utilities/page_result_object.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/order_by_enum.dart';
import '../../../utils/helpers/userexception.dart';
import '../../../utils/providers/base_provider.dart';

class DirectorController extends Cubit<BaseState> {
  final BaseProvider<Director> _baseProvider;

  DirectorController()
      : _baseProvider = BaseProvider<Director>('/Director'),
        super(InputWaiting());

  var directors;

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchDirectors();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else {
        directors = response?.resultList;
      }

      if (directors == null) {
        return null;
      } else {
        emit(DirectorLoadedState(directors));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Directors Data"));
    }
  }

  Future<PageResultObject<Director>?> fetchDirectors() async {
    try {
      var searchRequest = DirectorSearchObject(
          orderBy: OrderBy.lastAddedDirectors.value, isDescending: true);

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        fromJson: (json) => Director.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  void sortDirectorsByCreationDate() {
    List<Director> directorsList = List<Director>.from(directors);
    directorsList.sort((a, b) => b.creationDate!.compareTo(a.creationDate!));
    directors = directorsList;
  }

  Future<void> deleteDirector(int directorId) async {
    try {
      var response = await _baseProvider.delete(id: directorId);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "The director has been successfully deleted"));

          directors.removeWhere((director) => director.id == directorId);

          sortDirectorsByCreationDate();

          if (directors.isEmpty) {
            emit(EmptyListState());
          } else {
            emit(DirectorLoadedState(directors));
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

  Future<void> insertDirector(DirectorInsertRequest request) async {
    try {
      var response =
          await _baseProvider.insert(request: request, isQueryable: false);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "Director has been inserted successfully"));

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

  Future<void> updateDirector(
      int directorId, DirectorUpdateRequest request) async {
    try {
      var response = await _baseProvider.update(
          id: directorId, request: request, isSpecificMethod: true);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "Director has been updated successfully"));
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  void directorUpdatedScreenError(String message) {
    emit(ShowErrorMessageState(message));
  }

  void directorInsertScreenError() {
    emit(ShowErrorMessageState("Please fill in all fields"));
  }

  void onDeleteDirectorPress(String message, int directorId) {
    emit(ShowQuestionMessageState(message, id: directorId));
  }
}

class DirectorLoadedState extends BaseState {
  List<Director>? directors;

  DirectorLoadedState(this.directors);
}
