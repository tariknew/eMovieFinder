import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:unicons/unicons.dart';

import '../../../utils/helpers/basestate.dart';
import 'package:emovie_finder_mobile/src/style/theme/theme.dart';
import 'navigation_screen_view_model.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/hometabscreen/home_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/searchtabscreen/search_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/profiletabscreen/profile_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/carttabscreen/cart_tab_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const String routeName = 'navigation';
  static const String path = '/navigation';

  Widget tab;
  NavigationScreen({required this.tab});
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  NavigationScreenViewModel viewModel = NavigationScreenViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.setSelectedIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    viewModel.router = GoRouter.of(context);
    return BlocProvider(
      create: (context) => viewModel,
      child: BlocConsumer<NavigationScreenViewModel , BaseState>(
        listener: (context, state) {
          if(state is HomeTabState){
            context.push(HomeTabScreen.path);
          }else if (state is SearchTabState){
            context.push(SearchTabScreen.path);
          }else if (state is CartTabState){
            context.push(CartTabScreen.path);
          }else if (state is ProfileTabState){
            context.push(ProfileTabScreen.path);
          }
        },
        builder:(context, state) => Scaffold(
          body: widget.tab,
          extendBody: true,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SafeArea(
              child: DotNavigationBar(
                boxShadow: const [
                  BoxShadow(
                    color: MyTheme.backGroundColor,
                    offset: Offset(0, 5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                selectedItemColor: MyTheme.gold,
                unselectedItemColor: MyTheme.gray,
                enablePaddingAnimation: false,
                onTap: (value) => viewModel.setSelectedIndex(value),
                currentIndex: viewModel.setCurrentIndex(context),
                borderRadius: 20,
                backgroundColor: MyTheme.blackOne,
                marginR: EdgeInsets.zero,
                paddingR: EdgeInsets.zero,
                dotIndicatorColor: Colors.transparent,
                items: [
                  DotNavigationBarItem(icon: const Icon(UniconsLine.estate)),
                  DotNavigationBarItem(icon: const Icon(EvaIcons.search)),
                  DotNavigationBarItem(icon: const Icon(EvaIcons.shoppingCart)),
                  DotNavigationBarItem(icon: const Icon(LineIcons.userCircle)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}