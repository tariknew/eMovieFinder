import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:emovie_finder_mobile/src/utils/helpers/basestate.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/introscreen/widgets/first_tab.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/introscreen/widgets/second_tab.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/introscreen/widgets/last_tab.dart';

class IntroScreenViewModel extends Cubit<BaseState>{
  IntroScreenViewModel():super(TabsState());

  late List<Widget> tabs = [
    FirstTab(changeIndexCallBack: changeIndex),
    SecondTab(changeIndexCallBack: changeIndex),
    LastTab(changeIndexCallBack: changeIndex)
  ];

  int currentIndex = 0;

  void changeIndex(int newIndex)async{
    if(newIndex == 3){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("introDone", true);
      emit(GoToWelcomeScreenAction());
      return;
    }
    currentIndex = newIndex ;
    emit(TabsState());
  }
}

class TabsState extends BaseState{}
class GoToWelcomeScreenAction extends BaseState{}
