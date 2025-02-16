import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/helpers/basestate.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/searchtabscreen/search_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/hometabscreen/home_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/profiletabscreen/profile_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/moviedetailtabscreen/movie_detail_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/carttabscreen/cart_tab_screen.dart';

class NavigationScreenViewModel extends Cubit<BaseState>{

  NavigationScreenViewModel():super(HomeTabState());

  GoRouter? router ;
  int selectedIndex = 0;

  // change the selected index of the pages in case of the tab is movie details tab will be the last selected index
  void setSelectedIndex(int index){
    if(index != 9){
      selectedIndex = index;
      updateState(index);
    }
  }

  // change the state of the code depend on the index from the setSelected state function
  void updateState(int index){
    if(index == 0){
      emit(HomeTabState());
    }else if (index == 1){
      emit(SearchTabState());
    }else if (index == 2){
      emit(CartTabState());
    }else if (index == 3){
      emit(ProfileTabState());
    }
  }

  // change the current selected icon depend on the route path
  int setCurrentIndex(BuildContext context){
    final String location = GoRouterState.of(context).uri.toString();

    if(location == HomeTabScreen.path){
      selectedIndex = 0;
      return 0;
    }else if(location == SearchTabScreen.path){
      selectedIndex = 1;
      return 1;
    }else if(location == CartTabScreen.path){
      selectedIndex = 2;
      return 2;
    }else if(location == ProfileTabScreen.path){
      selectedIndex = 3;
      return 3;
    }else if(location == MovieDetailTabScreen.path){
      return selectedIndex;
    }
    return 0;
  }
}

class HomeTabState extends BaseState{}
class SearchTabState extends BaseState{}
class CartTabState extends BaseState{}
class ProfileTabState extends BaseState{}
