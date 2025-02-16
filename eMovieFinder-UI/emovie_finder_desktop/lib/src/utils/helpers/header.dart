import 'package:emovie_finder_desktop/src/utils/helpers/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/screens/mainscreen/menu_view_model.dart';

class NewSide extends StatelessWidget {
  final Function fct;
  const NewSide({Key? key, required this.fct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                fct();
              }),
        if (!Responsive.isMobile(context))
          Expanded(
            child: Text(
              "${context.watch<SideMenuController>().screens_title[context.watch<SideMenuController>().currentSelectedIndex]}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
      ],
    );
  }
}


