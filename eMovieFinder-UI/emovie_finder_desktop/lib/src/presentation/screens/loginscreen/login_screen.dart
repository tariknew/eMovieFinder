import 'package:flutter/material.dart';

import '../../../utils/helpers/responsive_helper.dart';
import '../../../utils/helpers/utils.dart';
import '../../../utils/providers/constant_colors.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'Login Screen';

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = Utils.getscreensize(context);

    return Container(
        color: secondaryColor,
        height: Responsive.isDesktop(context)
            ? _size.width * .4
            : Responsive.isTablet(context)
            ? _size.width * .7
            : _size.width * 0.9,
        width: Responsive.isDesktop(context)
            ? _size.width * .4
            : Responsive.isTablet(context)
            ? _size.width * .7
            : _size.width * 0.9,
        padding:
        EdgeInsets.all(!Responsive.isMobile(context) ? defaultPadding : 8),
        child: LoginForm());
  }
}