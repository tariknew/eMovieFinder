import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:emovie_finder_mobile/src/models/dtos/requests/user/user_login_request.dart';
import 'package:emovie_finder_mobile/src/style/theme/theme.dart';
import 'package:emovie_finder_mobile/src/presentation/basewidgets/custom_textfield.dart';
import 'package:emovie_finder_mobile/src/utils/helpers/dialog.dart';
import '../../../utils/helpers/basestate.dart';
import '../../../utils/helpers/base_validator.dart';
import '../../../utils/providers/app_config_provider.dart';
import '../../../utils/providers/user_auth_provider.dart';
import '../confirmemailscreen/confirm_email_screen.dart';
import '../forgotpasswordscreen/forgot_password_screen.dart';
import '../navigationscreen/screen_tabs/hometabscreen/home_tab_screen.dart';
import '../registrationscreen/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';
  static const String path = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final BaseValidator validator = BaseValidator();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late UserAuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = UserAuthProvider();
    authProvider.provider = Provider.of<AppConfigProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    authProvider.provider = null;
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      UserLoginRequest request = UserLoginRequest(
        username: usernameController.text,
        password: passwordController.text
      );
      await authProvider.login(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserAuthProvider>(
      create: (context) => authProvider,
      child: BlocConsumer<UserAuthProvider, BaseState>(
      listener: (context, state) {
        if(state is GoToRegistrationScreenAction){
          context.goNamed(RegistrationScreen.routeName);
        }
        if (state is ShowLoadingState) {
          MyDialogUtils.showLoadingDialog(context, state.message);
        }
        if (state is HideDialog) {
          MyDialogUtils.hideDialog(context);
        }
        if (state is ShowSuccessMessageState) {
          MyDialogUtils.showSuccessMessage(
            context: context,
            message: state.message,
            posActionTitle: "Ok",
            posAction: authProvider.goToHomeScreen);
        }
        if (state is ShowErrorMessageState) {
          if (state.message == "Email address isn't confirmed") {
            MyDialogUtils.showFailMessage(
              context: context,
              message: state.message,
              posActionTitle: "Ok",
              posAction: authProvider.goToConfirmEmailScreen
            );
          } else {
            MyDialogUtils.showFailMessage(
              context: context,
              message: state.message,
              posActionTitle: "Try Again",
            );
          }
        }
        if(state is GoToConfirmEmailScreenAction){
          context.goNamed(ConfirmEmailScreen.routeName);
        }
        if (state is GoToHomeScreenAction) {
          GoRouter.of(context).goNamed(HomeTabScreen.routeName);
        }
        if(state is GoToForgotPasswordScreenAction) {
          GoRouter.of(context).pushNamed(ForgotPasswordScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset("assets/images/logo.png", width: 150),
                  Text(
                    "Login",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        MyTextFormField(
                          "Username",
                          EvaIcons.person,
                          (value) {
                            if (value.isEmpty){
                              return "The Username Field Can't be Empty";
                            }
                            return null;
                          },
                          usernameController,
                          TextInputType.name,
                        ),
                        MyPasswordTextFormField(
                          "Password",
                          EvaIcons.lock,
                          (value) {
                            if (value.isEmpty){
                              return "The Password Field Can't Be Empty";
                            }
                            return null;
                          },
                          passwordController,
                          TextInputType.visiblePassword,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: authProvider.goToForgotPasswordScreen,
                                style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                                ),
                                child: Text(
                                  "Forgot Password",
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: login,
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(MyTheme.gold),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't Have An Account?",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            TextButton(
                              onPressed: authProvider.goToRegistrationScreen,
                              style: ButtonStyle(
                                overlayColor: WidgetStateProperty.all(Colors.transparent),
                              ),
                              child: Text(
                                "Register An Account",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
    );
  }
}
