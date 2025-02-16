import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:emovie_finder_mobile/src/models/entities/user.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/editprofiletabscreen/edit_profile_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/profiletabscreen/profile_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/welcomescreen/welcome_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/loginscreen/login_screen.dart';
import 'package:emovie_finder_mobile/src/style/theme/theme.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/introscreen/intro_screen.dart';
import 'package:emovie_finder_mobile/src/utils/providers/app_config_provider.dart';
import 'package:emovie_finder_mobile/src/utils/helpers/user_roles_helper.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/registrationscreen/registration_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/forgotpasswordscreen/forgot_password_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/confirmemailscreen/confirm_email_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/navigation_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/hometabscreen/home_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/searchtabscreen/search_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/moviedetailtabscreen/movie_detail_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/carttabscreen/cart_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/orderhistorytabscreen/order_history_tab_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain storage preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var isFirstTime = prefs.getBool('introDone');

  token ??= '';
  isFirstTime ??= false;

  runApp(MyApp(token: token, isFirstTime: isFirstTime));

  FlutterNativeSplash.remove();
}

final rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  String token;
  bool isFirstTime;

  MyApp({super.key, required this.token, required this.isFirstTime});

  late var router = GoRouter(
      initialLocation: getInitialLocation(),
      navigatorKey: rootNavigatorKey,
      redirect: (context, state) async {
        var token = await AppConfigProvider().getValueFromStorage("token");

        final currentPath = state.uri.path;

        final isWelcomeScreen = currentPath == WelcomeScreen.path;
        final isIntroScreen = currentPath == IntroScreen.path;
        final isLoginScreen = currentPath == LoginScreen.path;
        final isRegistrationScreen = currentPath == RegistrationScreen.path;
        final isConfirmEmailScreen = currentPath == ConfirmEmailScreen.path;
        final isForgotPasswordScreen = currentPath == ForgotPasswordScreen.path;

        if (isWelcomeScreen ||
            isIntroScreen ||
            isLoginScreen ||
            isRegistrationScreen ||
            isForgotPasswordScreen ||
            isConfirmEmailScreen) {
          return null;
        }
        if (token.isNotEmpty) {
          dynamic userRole = AppConfigProvider().getUserRole(token);
          if (Jwt.isExpired(token) || (!UserRoles.hasValidRole(userRole))) {
            await AppConfigProvider().signOut();
            return LoginScreen.path;
          }
        } else if (token.isEmpty) {
          return LoginScreen.path;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: WelcomeScreen.path,
          name: WelcomeScreen.routeName,
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: IntroScreen.path,
          name: IntroScreen.routeName,
          builder: (context, state) => const IntroScreen(),
        ),
        GoRoute(
          path: LoginScreen.path,
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RegistrationScreen.path,
          name: RegistrationScreen.routeName,
          builder: (context, state) => RegistrationScreen(),
        ),
        GoRoute(
          path: ConfirmEmailScreen.path,
          name: ConfirmEmailScreen.routeName,
          builder: (context, state) => const ConfirmEmailScreen(),
        ),
        GoRoute(
          path: ForgotPasswordScreen.path,
          name: ForgotPasswordScreen.routeName,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: EditProfileTabScreen.path,
          name: EditProfileTabScreen.routeName,
          pageBuilder: (context, state) => MaterialPage(
            key: UniqueKey(),
            child: EditProfileTabScreen(
              user: state.extra as User,
            ),
          ),
        ),
        GoRoute(
          path: CartTabScreen.path,
          name: CartTabScreen.routeName,
          pageBuilder: (context, state) => MaterialPage(
            key: UniqueKey(),
            child: CartTabScreen(),
          ),
        ),
        GoRoute(
          path: OrderHistoryTabScreen.path,
          name: OrderHistoryTabScreen.routeName,
          pageBuilder: (context, state) => MaterialPage(
            key: UniqueKey(),
            child: OrderHistoryTabScreen(),
          ),
        ),
        ShellRoute(
            builder: (context, state, child) => NavigationScreen(tab: child),
            routes: [
              GoRoute(
                path: HomeTabScreen.path,
                name: HomeTabScreen.routeName,
                pageBuilder: (context, state) => MaterialPage(
                  key: UniqueKey(),
                  child: HomeTabScreen(),
                ),
              ),
              GoRoute(
                path: SearchTabScreen.path,
                name: SearchTabScreen.routeName,
                pageBuilder: (context, state) => MaterialPage(
                  key: UniqueKey(),
                  child: SearchTabScreen(),
                ),
              ),
              GoRoute(
                path: ProfileTabScreen.path,
                name: ProfileTabScreen.routeName,
                pageBuilder: (context, state) => MaterialPage(
                  key: UniqueKey(),
                  child: ProfileTabScreen(),
                ),
              ),
              GoRoute(
                path: MovieDetailTabScreen.path,
                name: MovieDetailTabScreen.routeName,
                pageBuilder: (context, state) => MaterialPage(
                  key: UniqueKey(),
                  child: MovieDetailTabScreen(
                    movieId: state.extra as num,
                  ),
                ),
              ),
            ]),
      ]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppConfigProvider())
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: MyTheme.theme,
      ),
    );
  }

  String getInitialLocation() {
    dynamic userRole = AppConfigProvider().getUserRole(token);
    if (!isFirstTime) {
      return IntroScreen.path;
    }
    return token.isEmpty ||
            Jwt.isExpired(token) ||
            (!UserRoles.hasValidRole(userRole))
        ? LoginScreen.path
        : HomeTabScreen.path;
  }
}
