import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utils/providers/app_config_provider.dart';
import '../hometabscreen/home_tab_screen.dart';

class PaymentSuccessTabScreen extends StatelessWidget {
  static const String routeName = 'paymentsuccesstabscreen';
  static const String path = '/paymentsuccesstabscreen';

  const PaymentSuccessTabScreen({super.key});

  void setCustomerRole() async {
    await AppConfigProvider().setCustomerRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Payment was successful!",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setCustomerRole();
                GoRouter.of(context).goNamed(HomeTabScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Return to home screen",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
