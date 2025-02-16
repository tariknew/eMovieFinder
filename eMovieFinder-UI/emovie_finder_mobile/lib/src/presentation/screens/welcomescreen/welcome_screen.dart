import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../style/theme/theme.dart';
import '../loginscreen/login_screen.dart';
import '../registrationscreen/registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = 'welcome';
  static const String path = '/';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(),
          Image.asset('assets/images/logo.png'),
          const Text("Welcome" , style: TextStyle(
              color: Colors.white ,
              fontWeight: FontWeight.w900,
              fontSize: 35,
              letterSpacing: 3
          ),),
          const SizedBox(height: 30,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: ElevatedButton(
                onPressed: (){
                  GoRouter.of(context).goNamed(LoginScreen.routeName);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(MyTheme.gold),
                  shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(width: 5 , color: MyTheme.gold)
                      )
                  ),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.displayMedium!,
                  ),
                )
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: ElevatedButton(
                onPressed: (){
                  GoRouter.of(context).goNamed(RegistrationScreen.routeName);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(MyTheme.backGroundColor),
                  shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(width: 2 , color: MyTheme.gold)
                      )
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Sign Up",
                    style: Theme.of(context).textTheme.displayMedium!,
                  ),
                )
            ),
          ),

        ],
      ),
    );
  }
}