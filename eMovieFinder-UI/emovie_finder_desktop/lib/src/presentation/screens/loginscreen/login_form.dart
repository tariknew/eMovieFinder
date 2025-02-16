import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/dtos/requests/user/user_login_request.dart';
import '../../../utils/helpers/base_state.dart';
import '../../../utils/helpers/default_button.dart';
import '../../../utils/helpers/default_text_form.dart';
import '../../../utils/helpers/dialog.dart';
import '../mainscreen/menu_view_model.dart';
import 'login_screen_view_model.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final textUsernameController = TextEditingController();
  final textPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AuthController authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = AuthController();
    context.read<SideMenuController>().currentSelectedIndex = 0;
  }

  @override
  void dispose() {
    textUsernameController.dispose();
    textPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthController>(
      create: (context) => authProvider,
      child: BlocConsumer<AuthController, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowSuccessMessageState) {
            MyDialogUtils.showSuccessDialog(
                context: context,
                message: state.message,
                posActionTitle: "Ok",
                posAction: () {
                  textUsernameController.clear();
                  textPasswordController.clear();
                  context.read<SideMenuController>()..buildMenu(true);
                });
          } else if (state is ShowErrorMessageState) {
            MyDialogUtils.showErrorDialog(
              context: context,
              message: state.message,
              posActionTitle: "Try Again",
            );
          } else if (state is ShowLoadingState) {
            MyDialogUtils.showLoadingDialog(context, state.message);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login Screen",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 40),
                defaultTextFormField(
                  controller: textUsernameController,
                  inputtype: TextInputType.emailAddress,
                  hinttext: "Username",
                  onvalidate: (value) {
                    if (value!.isEmpty) return "Username mustn't be empty";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                defaultTextFormField(
                  obscure: authProvider.showpassword,
                  controller: textPasswordController,
                  inputtype: TextInputType.text,
                  hinttext: "Password",
                  onvalidate: (value) {
                    if (value!.isEmpty) return "Password mustn't be empty";
                    return null;
                  },
                  suffixIcon: InkWell(
                    child: Icon(
                      authProvider.showpassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onTap: () {
                      setState(() {
                        authProvider.onchangepasswordvisibility();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                defaultButton(
                  text: "Sign In",
                  height: 50,
                  onpress: () {
                    if (_formKey.currentState!.validate()) {
                      UserLoginRequest request = UserLoginRequest(
                        username: textUsernameController.text,
                        password: textPasswordController.text,
                      );

                      authProvider.login(request);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
