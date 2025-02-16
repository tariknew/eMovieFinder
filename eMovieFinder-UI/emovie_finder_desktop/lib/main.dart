import 'package:emovie_finder_desktop/src/presentation/screens/actorscreen/actor_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/categoryscreen/category_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/countryscreen/country_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/directorscreen/director_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/loginscreen/login_screen.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/loginscreen/login_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/mainscreen/main_screen.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/mainscreen/menu_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/movieactorscreen/movie_actor_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/moviefavouritescreen/movie_favourite_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/moviescreen/movie_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/ordersalesreportscreen/order_sales_report_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/presentation/screens/userscreen/user_screen_view_model.dart';
import 'package:emovie_finder_desktop/src/utils/providers/app_config_provider.dart';
import 'package:emovie_finder_desktop/src/utils/providers/recommender_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:emovie_finder_desktop/src/utils/providers/constant_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider<AuthController>(
          create: (context) => AuthController(),
        ),
        BlocProvider<ActorController>(
          create: (context) => ActorController(),
        ),
        BlocProvider<CountryController>(
          create: (context) => CountryController(),
        ),
        BlocProvider<CategoryController>(
          create: (context) => CategoryController(),
        ),
        BlocProvider<DirectorController>(
          create: (context) => DirectorController(),
        ),
        BlocProvider<MovieController>(
          create: (context) => MovieController(),
        ),
        BlocProvider<OrderController>(
          create: (context) => OrderController(),
        ),
        BlocProvider<UserController>(
          create: (context) => UserController(),
        ),
        BlocProvider<RecommenderController>(
          create: (context) => RecommenderController(),
        ),
        BlocProvider<MovieActorController>(
          create: (context) => MovieActorController(),
        ),
        BlocProvider<MovieFavouriteController>(
          create: (context) => MovieFavouriteController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppConfigProvider(),
        ),
        ChangeNotifierProxyProvider<AuthController, SideMenuController>(
          create: (context) => SideMenuController(null),
          update: (context, authController, previousMenu) =>
              SideMenuController(authController),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eMovieFinder Desktop Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MainScreen(),
    );
  }
}

