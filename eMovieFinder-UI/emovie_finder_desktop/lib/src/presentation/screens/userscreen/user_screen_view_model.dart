import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/dtos/requests/user/user_insert_request.dart';
import '../../../models/dtos/requests/user/user_update_request.dart';
import '../../../models/entities/user.dart';
import '../../../models/searchobjects/user_search_object.dart';
import '../../../models/utilities/page_result_object.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/order_by_enum.dart';
import '../../../utils/helpers/userexception.dart';
import '../../../utils/providers/base_provider.dart';

class UserController extends Cubit<BaseState> {
  final BaseProvider<User> _baseProvider;

  UserController()
      : _baseProvider = BaseProvider<User>('/User'),
        super(InputWaiting());

  var users;

  Future<dynamic> fetchData() async {
    emit(LoadingState());
    try {
      final response = await fetchUsers();

      if (response?.count == 0) {
        emit(EmptyListState());
      } else {
        users = response?.resultList;
      }

      if (users == null) {
        return null;
      } else {
        emit(UserLoadedState(users));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The Users Data"));
    }
  }

  Future<PageResultObject<User>?> fetchUsers() async {
    try {
      var searchRequest = UserSearchObject(
          isIdentityUserIncluded: true,
          orderBy: OrderBy.lastAddedUsers.value,
          isDescending: true
      );

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        fromJson: (json) => User.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<PageResultObject<User>?> performSearch(String userName) async {
    try {
      var searchRequest = UserSearchObject(
          username: userName,
          isIdentityUserIncluded: true
      );

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        fromJson: (json) => User.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<void> getSearchResults(String userName) async {
    emit(LoadingState());
    try {
    var response = await performSearch(userName);

    if(response?.count == 0) {
      emit(EmptyListState());
    }
    else if (response == null) {
      emit(ShowErrorMessageState("Couldn't Load The Users"));
    } else {
      emit(UserLoadedState(response.resultList));
    }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  Future<void> insertUser(UserInsertRequest request) async {
    try {
      var response =
      await _baseProvider.insert(request: request, isQueryable: false);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "User has been inserted successfully"));

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

  Future<void> updateUser(
      int userId, UserUpdateRequest request) async {
    try {
      var response = await _baseProvider.update(
          id: userId, request: request, isSpecificMethod: true);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "User has been updated successfully"));
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  Future<void> softDeleteUser(int userId) async {
    try {
      var response = await _baseProvider.delete(id: userId);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(ShowSuccessMessageState(
              "The user has been successfully soft deleted"));

          users.removeWhere((user) => user.id == userId);

          if (users.isEmpty) {
            emit(EmptyListState());
          } else {
            emit(UserLoadedState(users));
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

  void userUpdatedScreenError(String message) {
    emit(ShowErrorMessageState(message));
  }

  void userInsertScreenError() {
    emit(ShowErrorMessageState("Please fill in all fields"));
  }

  void onDeleteUserPress(String message, int userId) {
    emit(ShowQuestionMessageState(message, id: userId));
  }
}

class UserLoadedState extends BaseState {
  List<User>? users;

  UserLoadedState(this.users);
}
