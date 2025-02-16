import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/utilities/menu_model.dart';
import '../../../utils/helpers/dialog.dart';
import '../../../utils/helpers/responsive_helper.dart';
import '../../../utils/providers/constant_colors.dart';
import '../loginscreen/login_screen_view_model.dart';
import 'menu_view_model.dart';

class SideMenu extends StatelessWidget {
  SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Consumer<SideMenuController>(
            builder: (context, menuController, child) =>
                DrawerListTile(listOfModel: menuController.menuModelList),
          )
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile({
    Key? key,
    required this.listOfModel,
  }) : super(key: key);

  final List<MenuModel> listOfModel;

  @override
  Widget build(BuildContext context) {
    List<Widget> _list_of_listTile = [];
    for (int i = 0; i < listOfModel.length; i++)
      _list_of_listTile.add(InkWell(
        child: Container(
          color: listOfModel[i].isselected!
              ? Colors.grey.withOpacity(0.3)
              : secondaryColor,
          child: ListTile(
            selected: true,
            selectedColor: Colors.grey.shade400,
            onTap: () async {
              if (i != 9) {
                context.read<SideMenuController>().onChangeSelectedMenu(i);

                if (Responsive.isMobile(context) ||
                    Responsive.isBigMobile(context) ||
                    Responsive.isTablet(context)) Navigator.pop(context);
              } else {
                MyDialogUtils.showQuestionDialog(
                    context: context,
                    message: "Are You Sure You Want To Sign Out Of Your Account?",
                    posActionTitle: "Yes",
                    posAction: () async {
                      MyDialogUtils.showSuccessDialog(
                          context: context,
                          message: "You have successfully logged out",
                          posActionTitle: "Ok",
                          posAction: () async {
                            await context.read<AuthController>()..SignOut();
                            context.read<SideMenuController>()..buildMenu(false);
                            context.read<SideMenuController>().currentSelectedIndex = 0;
                          });
                    },
                    negActionTitle: "No");
              }
            },
            horizontalTitleGap: 0.0,
            title: Text(
              listOfModel[i].title!,
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ),
      ));
    return Column(
      children: [..._list_of_listTile],
    );
  }
}