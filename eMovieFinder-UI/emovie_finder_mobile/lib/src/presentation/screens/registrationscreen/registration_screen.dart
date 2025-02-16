import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/dtos/requests/user/user_register_request.dart';
import '../../../utils/helpers/basestate.dart';
import '../../../utils/helpers/image_helper.dart';
import '../../../utils/helpers/base_validator.dart';
import '../../../utils/providers/app_config_provider.dart';
import 'package:emovie_finder_mobile/src/style/theme/theme.dart';
import 'package:emovie_finder_mobile/src/utils/helpers/dialog.dart';
import 'package:emovie_finder_mobile/src/presentation/basewidgets/custom_textfield.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/loginscreen/login_screen.dart';
import '../../../utils/providers/user_auth_provider.dart';
import '../confirmemailscreen/confirm_email_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = "register";
  static const String path = "/register";

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();

  final BaseValidator validator = BaseValidator();

  String selectedImage = "assets/images/avatar.png";
  String? _base64Image;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();

  late UserAuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = UserAuthProvider();
    authProvider.provider =
        Provider.of<AppConfigProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    passwordConfirmation.dispose();
    authProvider.provider = null;
  }

  void setImage() async {
    _base64Image = await ImageHelper.getImage(context);
    if (_base64Image != null) {
      authProvider.updateUserImage(_base64Image!);
    } else {
      return;
    }
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      String? base64Image;

      if (!selectedImage.startsWith('assets/images/avatar.png')) {
        base64Image = selectedImage;
      }

      UserRegisterRequest request = UserRegisterRequest(
          username: username.text,
          email: email.text,
          password: password.text,
          confirmPassword: passwordConfirmation.text,
          imagePlainText: base64Image);

      await authProvider.register(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authProvider,
      child: BlocConsumer<UserAuthProvider, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          }
          if (state is ShowLoadingState) {
            MyDialogUtils.showLoadingDialog(context, state.message);
          }
          if (state is ShowSuccessMessageState) {
            MyDialogUtils.showSuccessMessage(
                context: context,
                message: state.message,
                posActionTitle: "Ok",
                posAction: authProvider.goToConfirmEmailScreen);
          }
          if (state is ShowErrorMessageState) {
            MyDialogUtils.showFailMessage(
              context: context,
              message: state.message,
              posActionTitle: "Try Again",
            );
          }
          if (state is GoToConfirmEmailScreenAction) {
            context.goNamed(ConfirmEmailScreen.routeName);
          }
          if (state is GoToLoginScreenAction) {
            GoRouter.of(context).goNamed(LoginScreen.routeName);
          }
          if (state is ImageUpdatedState) {
            selectedImage = state.base64Image;
          }
          if (state is InputWaiting) {
            context.pop();
          }
        },
        builder: (context, state) => Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create  ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        height: 30,
                      ),
                      Text(
                        "  Account",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: 116,
                        height: 113,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: !selectedImage
                                  .startsWith('assets/images/avatar.png')
                              ? Image.memory(
                                  base64Decode(selectedImage),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  selectedImage,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: setImage,
                          child: const CircleAvatar(
                            backgroundColor: MyTheme.gold,
                            child: Icon(
                              Icons.edit,
                              color: MyTheme.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        MyTextFormField(
                          "Username",
                          EvaIcons.person,
                          validator.usernameValidation,
                          username,
                          TextInputType.name,
                        ),
                        MyTextFormField(
                          "Email",
                          EvaIcons.email,
                          validator.emailValidation,
                          email,
                          TextInputType.emailAddress,
                        ),
                        MyPasswordTextFormField(
                          "Password",
                          EvaIcons.lock,
                          validator.passwordValidation,
                          password,
                          TextInputType.visiblePassword,
                        ),
                        MyPasswordTextFormField(
                          "Re-Password",
                          EvaIcons.lock,
                          (value) => validator.confirmPasswordValidation(
                            passwordConfirmation.text,
                            password.text,
                          ),
                          passwordConfirmation,
                          TextInputType.visiblePassword,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: register,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(MyTheme.gold),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Create An Account",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already Have An Account?",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            TextButton(
                              onPressed: authProvider.goToLoginScreen,
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
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
        ),
      ),
    );
  }
}
