import 'package:emovie_finder_desktop/src/presentation/screens/loginscreen/login_screen.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/mainscreen/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/helpers/header.dart';
import '../../../utils/helpers/responsive_helper.dart';
import '../../../utils/providers/constant_colors.dart';
import 'menu_view_model.dart';

class MainScreen extends StatelessWidget {
  static const String routeName = 'Main Screen';

  @override
  Widget build(BuildContext context) {
    final currentScreen = context
        .watch<SideMenuController>()
        .screens[context.watch<SideMenuController>().currentSelectedIndex];
    return Scaffold(
      key: context.read<SideMenuController>().getscaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      if (currentScreen is! LoginScreen)
                        NewSide(fct: () {
                          context.read<SideMenuController>().main_controlMenu();
                        }),
                      const SizedBox(height: defaultPadding),
                      currentScreen,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
