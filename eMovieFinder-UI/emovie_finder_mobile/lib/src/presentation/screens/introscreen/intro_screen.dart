import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:emovie_finder_mobile/src/utils/helpers/basestate.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/introscreen/intro_screen_view_model.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/welcomescreen/welcome_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static const String routeName = 'intro';
  static const String path = '/intro';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  IntroScreenViewModel viewModel = IntroScreenViewModel();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IntroScreenViewModel>(
      create: (context) => viewModel,
      child: BlocConsumer<IntroScreenViewModel , BaseState>(
        listener: (context, state) {
          if(state is GoToWelcomeScreenAction){
            GoRouter.of(context).goNamed(WelcomeScreen.routeName);
          }
        },
        builder: (context, state) => Scaffold(body: viewModel.tabs[viewModel.currentIndex]),
      ),
    );
  }
}