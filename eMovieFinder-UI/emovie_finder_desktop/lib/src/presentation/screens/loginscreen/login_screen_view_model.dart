import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/dtos/requests/user/user_login_request.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/userexception.dart';
import '../../../utils/providers/app_config_provider.dart';
import '../../../utils/providers/base_provider.dart';

class AuthController extends Cubit<BaseState> {
  final BaseProvider _baseProvider = BaseProvider();

  AuthController() : super(InputWaiting());

  bool showpassword = false;
  bool loggedUser = false;

  AppConfigProvider? provider = AppConfigProvider();

  onchangepasswordvisibility() {
    showpassword = !showpassword;
  }

  Future<void> login(UserLoginRequest request) async {
    emit(ShowLoadingState("Signing You In"));
    try {
      String query = '/AuthManagement/Login'
          '?Username=${request.username}&Password=${request.password}';

      var response = await _baseProvider.insert(
          request: request,
          query: query,
          isQueryable: true,
          isSpecificMethod: true);

      if (response != null) {
        var data = response.data;

        if (response.statusCode! < 299) {
          if (data['roles'] != null && data['roles'] is List) {
            List<dynamic> roles = data['roles'];

            if (!roles.contains("Administrator")) {
              loggedUser = false;

              emit(HideDialog());
              emit(ShowErrorMessageState("You don't have access, only for administrators"));

              return;
            }
          }
          provider!.putValueInStorage("token", data['token']);

          loggedUser = true;

          emit(HideDialog());
          emit(ShowSuccessMessageState("Login successful"));
        } else {
          String errorMessage = UserException.extractExceptionMessage(data);

          loggedUser = false;

          emit(HideDialog());
          emit(ShowErrorMessageState(errorMessage));
        }
      }
    } catch (e) {
      loggedUser = false;

      emit(HideDialog());
      emit(ShowErrorMessageState(e.toString().split('Exception: ').last));
    }
  }

  Future SignOut() async {
    provider?.signOut();
    loggedUser = false;
  }
}



