import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/searchobjects/user_search_object.dart';
import '../../../../../models/utilities/page_result_object.dart';
import '../../../../../models/searchobjects/movie_favourite_search_object.dart';
import '../../../../../models/entities/moviefavourite.dart';
import '../../../../../models/entities/user.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/order_by_enum.dart';
import '../../../../../utils/providers/app_config_provider.dart';
import '../../../../../utils/providers/base_provider.dart';
import '../../navigation_screen_view_model.dart';

class ProfileTabScreenViewModel extends Cubit<BaseState> {
  final BaseProvider _baseProvider = BaseProvider();

  ProfileTabScreenViewModel() : super(LoadingState());

  var favouriteMovies;

  String? userName = '';
  String? email = '';
  String? identityUserId = '';
  dynamic userImage;

  NavigationScreenViewModel? homeScreenViewModel;

  void getUserData() async {
    emit(LoadingState());
    try {
      var userId = await AppConfigProvider().getValueFromStorage("userId");
      var token = await AppConfigProvider().getValueFromStorage("token");

      Map<String, dynamic>? decodedToken = AppConfigProvider().decodeToken(
          token);

      userName = decodedToken?['sub'] as String?;
      email = decodedToken?['email'] as String?;
      identityUserId = decodedToken?['Id'] as String?;

      var searchRequest = MovieFavouriteSearchObject(
          userId: int.parse(userId),
          isUserIncluded: true,
          isMovieIncluded: true,
          orderBy: OrderBy.lastAddedFavouriteMovies.value,
          isDescending: true
      );

      var response = await getFavouriteMovies(searchRequest);

      favouriteMovies = response?.resultList.map((favourite) {
        return favourite.movie;
      }).toList();

      if (response?.resultList != null && response!.resultList.isNotEmpty) {
        var firstObject = response.resultList[0];
        userImage = firstObject.user.image;
      } else {
        var userData = await getUserById(int.parse(userId));

        userImage = userData?.image;
      }

      if (response == null) {
        emit(ShowErrorMessageState("Couldn't Load The User Data"));
      } else {
        var userData = User(
          id: int.parse(userId),
          image: userImage,
          identityUserId: int.parse(identityUserId!),
          username: userName,
          email: email
        );
        emit(DataLoadedState(favouriteMovies, userData));
      }
    } catch (e) {
      emit(ShowErrorMessageState("Couldn't Load The User Data"));
    }
  }

  Future<User?> getUserById(num userId) async {
    try {
      String query = '/User';

      var searchRequest = UserSearchObject(
          isIdentityUserIncluded: true
      );

      var response = await _baseProvider.getById(
        id: userId as int,
        searchRequest: searchRequest,
        query: query,
        fromJson: (json) => User.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
      return null;
    }
  }

  Future<PageResultObject<dynamic>?> getFavouriteMovies(
      MovieFavouriteSearchObject searchRequest) async {
    try {
      String query = '/MovieFavourite';

      var response = await _baseProvider.get(
        searchRequest: searchRequest,
        query: query,
        fromJson: (json) => MovieFavourite.fromJson(json),
      );

      return response;
    } catch (e) {
      emit(ShowErrorMessageState(e
          .toString()
          .split('Exception: ')
          .last));
      return null;
    }
  }

  void goToDetailsScreen(num movie) {
    emit(MovieDetailsAction(movie));
  }

  void onSignOutPress(String message) {
    emit(ShowQuestionMessageState(message));
  }

  void signOut() async {
    await AppConfigProvider().signOut();
    emit(SignOutAction());
  }

  void goToEditProfileScreen(User user) {
    emit(EditProfileAction(user));
  }

  void goToOrdersHistoryScreen() {
    emit(OrdersHistoryAction());
  }

  void onPressBackAction(){
    emit(BackAction());
  }
}

class DataLoadedState extends BaseState {
  List<dynamic>? favouriteMovies;
  User user;

  DataLoadedState(this.favouriteMovies, this.user);
}

class SignOutAction extends BaseState {}

class OrdersHistoryAction extends BaseState {}

class EditProfileAction extends BaseState {
  User user;

  EditProfileAction(this.user);
}

class BackAction extends BaseState{}
