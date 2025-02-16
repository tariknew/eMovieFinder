import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../presentation/screens/navigationscreen/screen_tabs/carttabscreen/payment_cancel_tab_screen.dart';
import '../../presentation/screens/navigationscreen/screen_tabs/carttabscreen/payment_success_tab_screen.dart';
import 'package:emovie_finder_mobile/src/presentation/screens/navigationscreen/screen_tabs/carttabscreen/cart_tab_screen_view_model.dart';
import 'package:emovie_finder_mobile/src/utils/providers/paypal_config.dart';

class PayPalProvider extends ChangeNotifier {
  late CartTabScreenViewModel viewModel = CartTabScreenViewModel();

  Future<void> startPaymentProcess(
      BuildContext context, dynamic totalAmount) async {
    try {
      final accessToken = await _getAccessToken();
      final orderUrl = await _createOrder(accessToken, totalAmount);
      _redirectToPayPal(context, orderUrl);
    } catch (e) {
      throw Exception("Error during paypal payment process");
    }
  }

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('$sandboxUrl/v1/oauth2/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception("Failed to obtain paypal access token");
    }
  }

  Future<String> _createOrder(String accessToken, dynamic total) async {
    final response = await http.post(
      Uri.parse('$sandboxUrl/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'amount': {
              'currency_code': 'EUR',
              'value': total,
            },
          },
        ],
        'application_context': {
          'return_url': 'https://your-success-url.com',
          'cancel_url': 'https://your-cancel-url.com',
        }
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final approvalUrl =
          data['links'].firstWhere((link) => link['rel'] == 'approve')['href'];

      return approvalUrl;
    } else {
      throw Exception("Failed to create paypal order");
    }
  }

  void _redirectToPayPal(BuildContext context, String approvalUrl) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            title: const Text('PayPal Payment'),
            titleTextStyle: const TextStyle(color: Colors.white)),
        body: WebViewWidget(
            controller: _createWebViewController(context, approvalUrl)),
      );
    }));
  }

  WebViewController _createWebViewController(
      BuildContext context, String approvalUrl) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.startsWith('https://your-success-url.com')) {
              viewModel.removeAllFromCart();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const PaymentSuccessTabScreen(),
                ),
              );
            } else if (url.startsWith('https://your-cancel-url.com')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const PaymentCancelTabScreen(),
                ),
              );
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(approvalUrl));
  }
}
