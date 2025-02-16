import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/dtos/requests/user/user_change_profile_details_request.dart';
import '../../../../../models/entities/user.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/userexception.dart';
import '../../../../../utils/providers/base_provider.dart';

class EditProfileTabScreenViewModel extends Cubit<BaseState> {
  final BaseProvider _baseProvider;

  User user;

  EditProfileTabScreenViewModel(this.user)
      : _baseProvider = BaseProvider('/UserAccount/'),
        super(InputWaiting());

  final formKey = GlobalKey<FormState>();

  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  String? userImage = '';

  void onPressBackAction() {
    emit(BackAction());
  }

  void goToHomeScreen(){
    emit(GoToHomeScreenAction());
  }

  void initData() {
    userImage = user.image;
    userName.text = user.username!;
  }

  clearFields() {
    email.clear();
    currentPassword.clear();
    newPassword.clear();
  }

  Future<void> updateUserProfile(
      UserChangeProfileDetailsRequest request) async {
      if (formKey.currentState!.validate()) {
        emit(ShowLoadingState("Updating Your Profile"));
        try {
          String query = 'ChangeUserProfileDetails';

          var response = await _baseProvider.update(
              request: request, query: query, isSpecificMethod: true);

          if (response != null) {
            var data = response.data;

            if (response.statusCode! < 299) {
              emit(HideDialog());
              emit(ShowSuccessMessageState(
                  "Profile has been updated successfully"));
              clearFields();
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

  String? emailCharacterValidation(String input) {
    if(input.isEmpty) {
      return null;
    }
    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
            r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(input)) {
      return "Please Enter A Valid Email";
    }
    return null;
  }

  bool validateForm() {
    if (currentPassword.text.isNotEmpty && newPassword.text.isEmpty) {
      emit(ShowErrorMessageState(
          "Please Enter A New Password To Change Your Current Password"));
      return false;
    }

    if (currentPassword.text.isEmpty && newPassword.text.isNotEmpty) {
      emit(ShowErrorMessageState(
          "Please Enter Your Current Password To Set A New Password"));
      return false;
    }

    return true;
  }

  String? passwordValidation(String input) {
    if(input.isEmpty) {
      return null;
    }
    if (input.isNotEmpty && currentPassword.text.isEmpty) {
      return 'Please enter the current password if you provide a new password';
    }
    if (input.length < 8) {
      return "The Password Must be At Least 8 Characters Long";
    }
    return null;
  }

  String? currentPasswordValidation(String input) {
    if(input.isEmpty) {
      return null;
    }
    if (input.isNotEmpty && newPassword.text.isEmpty) {
      return 'Please enter a new password if you provided the current password';
    }
    return null;
  }

  void updateProfileScreenError(){
    emit(ShowErrorMessageState("Action not completed, because you have not changed at least one input field (nothing to save)"));
  }
}

class InputWaiting extends BaseState {}

class BackAction extends BaseState {}

class GoToHomeScreenAction extends BaseState{}
