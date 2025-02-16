import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../models/dtos/requests/user/user_change_profile_details_request.dart';
import '../../../../../models/entities/user.dart';
import '../../../../../style/theme/theme.dart';
import '../../../../../utils/helpers/basestate.dart';
import '../../../../../utils/helpers/dialog.dart';
import '../../../../../utils/helpers/image_helper.dart';
import '../../../../basewidgets/custom_textfield.dart';
import '../hometabscreen/home_tab_screen.dart';
import 'edit_profile_tab_screen_view_model.dart';

class EditProfileTabScreen extends StatefulWidget {
  User user;

  EditProfileTabScreen({required this.user, super.key});

  static const String routeName = 'editprofiletabscreen';
  static const String path = '/editprofiletabscreen';

  @override
  State<EditProfileTabScreen> createState() => _EditProfileTabScreenState();
}

class _EditProfileTabScreenState extends State<EditProfileTabScreen> {
  late EditProfileTabScreenViewModel viewModel;

  String? _base64Image;

  @override
  void initState() {
    super.initState();
    viewModel = EditProfileTabScreenViewModel(widget.user);
    viewModel.initData();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.userName.dispose();
    viewModel.email.dispose();
    viewModel.currentPassword.dispose();
    viewModel.newPassword.dispose();
  }

  void setImage() async {
    _base64Image = await ImageHelper.getImage(context);
    if (_base64Image != null) {
      setState(() {
        viewModel.userImage = _base64Image;
      });
    } else {
      return;
    }
  }

  void onUpdateUserProfile() async {
      var request = UserChangeProfileDetailsRequest(
          identityUserId: widget.user.identityUserId,
          email: viewModel.email.text.isNotEmpty ? viewModel.email.text : null,
          currentPassword: viewModel.currentPassword.text.isNotEmpty
              ? viewModel.currentPassword.text
              : null,
          newPassword: viewModel.newPassword.text.isNotEmpty
              ? viewModel.newPassword.text
              : null,
          imagePlainText: _base64Image != null && _base64Image!.isNotEmpty
              ? _base64Image
              : null);

      viewModel.updateUserProfile(request);

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileTabScreenViewModel>(
      create: (context) => viewModel,
      child: BlocConsumer<EditProfileTabScreenViewModel, BaseState>(
        listener: (context, state) {
          if (state is HideDialog) {
            MyDialogUtils.hideDialog(context);
          } else if (state is ShowLoadingState) {
            MyDialogUtils.showLoadingDialog(context, state.message);
          } else if (state is ShowSuccessMessageState) {
            MyDialogUtils.showSuccessMessage(
                context: context, message: state.message, posActionTitle: "Ok",
                posAction: viewModel.goToHomeScreen);
          } else if (state is ShowErrorMessageState) {
            MyDialogUtils.showFailMessage(
                context: context,
                message: state.message,
                posActionTitle: "Try Again");
          } else if (state is GoToHomeScreenAction) {
            GoRouter.of(context).goNamed(HomeTabScreen.routeName);
          } else if (state is BackAction) {
            context.pop(context);
          } else if (state is InputWaiting) {
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
                      IconButton(
                        onPressed: () {
                          viewModel.onPressBackAction();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      Text(
                        "Edit  ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        height: 30,
                      ),
                      Text(
                        "  Profile",
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
                          child: viewModel.userImage != null
                              ? Image.memory(
                                  base64Decode(viewModel.userImage!),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/avatar.png",
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
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        MyTextFormField(
                          "Username",
                          EvaIcons.person,
                          null,
                          viewModel.userName,
                          TextInputType.name,
                          readOnly: true,
                        ),
                        MyTextFormField(
                          "Email",
                          EvaIcons.email,
                          viewModel.emailCharacterValidation,
                          viewModel.email,
                          TextInputType.emailAddress,
                        ),
                        MyPasswordTextFormField(
                          "Current Password",
                          EvaIcons.lock,
                          viewModel.currentPasswordValidation,
                          viewModel.currentPassword,
                          TextInputType.visiblePassword,
                        ),
                        MyPasswordTextFormField(
                          "New Password",
                          EvaIcons.lock,
                          viewModel.passwordValidation,
                          viewModel.newPassword,
                          TextInputType.visiblePassword,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: onUpdateUserProfile,
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
                                "Update Profile",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
