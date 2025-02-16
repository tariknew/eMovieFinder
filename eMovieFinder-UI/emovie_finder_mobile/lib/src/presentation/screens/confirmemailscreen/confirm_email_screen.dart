import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/dtos/requests/user/user_confirm_email_request.dart';
import '../../../utils/helpers/basestate.dart';
import 'package:emovie_finder_mobile/src/utils/helpers/dialog.dart';
import 'package:emovie_finder_mobile/src/presentation/basewidgets/custom_textfield.dart';
import 'package:emovie_finder_mobile/src/style/theme/theme.dart';
import '../../../utils/helpers/base_validator.dart';
import '../../../utils/providers/app_config_provider.dart';
import '../../../utils/providers/user_auth_provider.dart';
import '../loginscreen/login_screen.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});
  static const String path = '/confirmemail';
  static const String routeName = 'confirmemail';

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final formKey = GlobalKey<FormState>();

  final BaseValidator validator = BaseValidator();

  TextEditingController emailController = TextEditingController();
  TextEditingController confirmationCodeController = TextEditingController();

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
    emailController.dispose();
    confirmationCodeController.dispose();
    authProvider.provider = null;
  }

  void confirmEmail() async {
    if (formKey.currentState!.validate()) {
      UserConfirmEmailRequest request = UserConfirmEmailRequest(
          Email: emailController.text,
          ConfirmationCode: confirmationCodeController.text
      );
      await authProvider.confirmEmail(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authProvider,
      child: BlocConsumer<UserAuthProvider, BaseState>(
        listener: (context, state) {
          if(state is GoToLoginScreenAction){
            GoRouter.of(context).goNamed(LoginScreen.routeName);
          }
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
                posAction: authProvider.goToLoginScreen);
          }
          if (state is ShowErrorMessageState) {
            MyDialogUtils.showFailMessage(
                context: context,
                message: state.message,
                posActionTitle: "Try Again");
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text("Confirm Email"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Please Enter your Email Address And Confirmation Code To Confirm Your Account" , style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        MyTextFormField("Email", EvaIcons.email, validator.emailValidation, emailController, TextInputType.emailAddress),
                        MyPasswordTextFormField(
                          "Confirmation Code",
                          EvaIcons.lock,
                              (value) {
                            if (value.isEmpty){
                              return "The Confirmation Code Field Can't Be Empty";
                            }
                            return null;
                          },
                          confirmationCodeController,
                          TextInputType.visiblePassword,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(20),
                          child: ElevatedButton(
                              onPressed: confirmEmail,
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(
                                      MyTheme.gold),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Confirm Email",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ],
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You have already confirmed your email?",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    TextButton(
                        onPressed: authProvider.goToLoginScreen,
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Text(
                          "Login",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}