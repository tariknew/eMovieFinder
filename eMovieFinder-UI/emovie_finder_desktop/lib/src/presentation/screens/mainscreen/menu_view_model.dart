import 'package:emovie_finder_desktop/src/presentation/screens/ordersalesreportscreen/order_sales_report_screen.dart';
import 'package:flutter/material.dart';
import '../../../models/utilities/menu_model.dart';
import '../actorscreen/actor_screen.dart';
import '../categoryscreen/category_screen.dart';
import '../countryscreen/country_screen.dart';
import '../directorscreen/director_screen.dart';
import '../loginscreen/login_screen.dart';
import '../loginscreen/login_screen_view_model.dart';
import '../movieactorscreen/movie_actor_screen.dart';
import '../moviefavouritescreen/movie_favourite_screen.dart';
import '../moviescreen/movie_screen.dart';
import '../userscreen/user_screen.dart';

class SideMenuController extends ChangeNotifier {
  final AuthController? _authProvider;

  int currentSelectedIndex = 0;

  SideMenuController(this._authProvider) {
    buildMenu(null);
  }

  void onChangeSelectedMenu(int index) {
    if (index == currentSelectedIndex) {
      screens[currentSelectedIndex] = _getRefreshedScreen(index);
    } else {
      for (int i = 0; i < menuModelList.length; i++) {
        if (i == index) {
          menuModelList[i].isselected = true;
        } else {
          menuModelList[i].isselected = false;
        }
      }
      currentSelectedIndex = index;
    }
    notifyListeners();
  }

  Widget? _getRefreshedScreen(int index) {
    switch (index) {
      case 0: return ActorScreen();
      case 1: return CategoryScreen();
      case 2: return CountryScreen();
      case 3: return DirectorScreen();
      case 4: return MovieScreen();
      case 5: return OrderSalesReportScreen();
      case 6: return UserScreen();
      case 7: return MovieActorScreen();
      case 8: return MovieFavouriteScreen();
      case 9: return LoginScreen();
      default: return ActorScreen();
    }
  }

  final GlobalKey<ScaffoldState> getscaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> getviewOrderscaffoldKey =
  GlobalKey<ScaffoldState>();

  void main_controlMenu() {
      if (!getscaffoldKey.currentState!.isDrawerOpen) {
        getscaffoldKey.currentState!.openDrawer();
      }
  }

  void viewOrder_controlMenu() {
    if (!getviewOrderscaffoldKey.currentState!.isDrawerOpen) {
      getviewOrderscaffoldKey.currentState!.openDrawer();
    }
  }

  final _offline_screen = [LoginScreen()];

  final _screens = [
    ActorScreen(),
    CategoryScreen(),
    CountryScreen(),
    DirectorScreen(),
    MovieScreen(),
    OrderSalesReportScreen(),
    UserScreen(),
    MovieActorScreen(),
    MovieFavouriteScreen()
  ];

  final _offline_screens_title = ['Login'];
  final _screens_title = [
    'Actors',
    'Categories',
    'Countries',
    'Directors',
    'Movies',
    'Train Model/Orders Count',
    'Users',
    'Movie Actors',
    'Movie Favourites'
  ];

  final List<MenuModel> _offline_menuModelList = [
  ];

  final List<MenuModel> _menuModelList = [
    MenuModel("Actors", isselected: true),
    MenuModel("Categories"),
    MenuModel("Countries"),
    MenuModel("Directors"),
    MenuModel("Movies"),
    MenuModel("Train Model/Orders Count"),
    MenuModel("Users"),
    MenuModel("Movie Actors"),
    MenuModel("Movie Favourites"),
    MenuModel("Logout"),
  ];

  List<MenuModel> menuModelList = [];
  var screens_title = [];
  var screens = [];

  void buildMenu(bool? loggedUser) {
    if (loggedUser == null || loggedUser == false) {
      screens_title = _offline_screens_title;
      menuModelList = _offline_menuModelList;
      screens = _offline_screen;
      currentSelectedIndex = 0;
    } else {
      screens_title = _screens_title;
      menuModelList = _menuModelList;
      screens = _screens;
      currentSelectedIndex = 0;
    }
    for (int i = 0; i < menuModelList.length; i++) {
      menuModelList[i].isselected = i == 0;
    }

    notifyListeners();
  }
}
