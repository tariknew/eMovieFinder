import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/dtos/requests/user/user_confirm_email_request.dart';
import '../../models/dtos/requests/user/user_login_request.dart';
import '../../models/dtos/requests/user/user_register_request.dart';
import '../helpers/basestate.dart';
import 'package:emovie_finder_mobile/src/utils/helpers/userexception.dart';
import 'app_config_provider.dart';
import 'base_provider.dart';

class UserAuthProvider extends Cubit<BaseState> {
  final BaseProvider _baseProvider = BaseProvider();

  UserAuthProvider() : super(InputWaiting());

  AppConfigProvider? provider;

  Future<void> login(UserLoginRequest request) async {
    emit(ShowLoadingState("Signing You In"));
    try {
      String query = '/AuthManagement/Login'
          '?Username=${request.username}&Password=${request.password}';

      var response = await _baseProvider.insert(
          request: request,
          query: query,
          isQueryable: true,
          isSpecificMethod: true
      );

      if(response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          provider!.putValueInStorage("token", data['token']);
          provider!.putValueInStorage("userId", data['userId'].toString());
          provider!.putValueInStorage("roles", data['roles'].toString());

          emit(HideDialog());
          emit(ShowSuccessMessageState("Welcome Back, ${request.username}"));
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

  Future<void> register(UserRegisterRequest request)async{
    emit(ShowLoadingState("Creating Your Account"));
    try {
      String query = '/AuthManagement/Register';

      var response = await _baseProvider.insert(
          request: request,
          query: query,
          isQueryable: false,
          isSpecificMethod: true
      );

      if(response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(HideDialog());
          emit(ShowSuccessMessageState("Account created successfully,"
              " please confirm your email to complete your registration"));
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

  Future<void> resetPassword(String email)async{
    emit(ShowLoadingState("Sending An Email"));
    try {
      String query = '/UserAccount/ResetPassword?email=$email';

      var response = await _baseProvider.insert(
          request: email,
          query: query,
          isQueryable: true,
          isSpecificMethod: true
      );

      if(response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(HideDialog());
          emit(ShowSuccessMessageState(
              "A new password has been sent to the email successfully!"));
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

  Future<void> confirmEmail(UserConfirmEmailRequest request) async {
    emit(ShowLoadingState("Confirming Your Account"));
    try {
      String query = '/UserAccount/ConfirmEmail'
          '?Email=${request.Email}&ConfirmationCode=${request.ConfirmationCode}';

      var response = await _baseProvider.insert(
          request: request,
          query: query,
          isQueryable: true,
          isSpecificMethod: true
      );

      if(response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          emit(HideDialog());
          emit(ShowSuccessMessageState(
              "Email confirmed! Your registration is successful"));
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

  void goToHomeScreen(){
    emit(GoToHomeScreenAction());
  }

  void goToRegistrationScreen(){
    emit(GoToRegistrationScreenAction());
  }

  void goToLoginScreen(){
    emit(GoToLoginScreenAction());
  }

  void goToForgotPasswordScreen(){
    emit(GoToForgotPasswordScreenAction());
  }

  void goToConfirmEmailScreen(){
    emit(GoToConfirmEmailScreenAction());
  }

  void updateUserImage(String base64Image) {
    emit(ImageUpdatedState(base64Image));
  }
}

class InputWaiting extends BaseState {}
class GoToHomeScreenAction extends BaseState {}
class GoToRegistrationScreenAction extends BaseState {}
class GoToLoginScreenAction extends BaseState {}
class GoToConfirmEmailScreenAction extends BaseState {}
class GoToForgotPasswordScreenAction extends BaseState {}

class ImageUpdatedState extends BaseState {
  final String base64Image;

  ImageUpdatedState(this.base64Image);
}

