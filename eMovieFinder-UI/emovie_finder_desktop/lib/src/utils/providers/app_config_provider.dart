import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigProvider extends ChangeNotifier {
  String _value = '';

  void putValueInStorage(String key, String value) async {
    _value = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value.isNotEmpty) {
      prefs.setString(key, value);
    }
    notifyListeners();
  }

  Future<String> getValueFromStorage(String key)async{
    if(_value.isEmpty){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _value = prefs.getString(key) ?? '';
    }
    return _value;
  }

  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');

    notifyListeners();
  }

  Map<String, dynamic>? decodeToken(String token) {
    if(token.isNotEmpty) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      return decodedToken;
    }
    return null;
  }

  dynamic getUserRole(String token) {
    if (token.isNotEmpty) {
      final Map<String, dynamic>? decodedToken = decodeToken(token);

      if (decodedToken != null && decodedToken.containsKey('role')) {
        final role = decodedToken['role'];

        if (role is String) {
          return role;
        } else if (role is List) {
          return role.cast<String>();
        }
      }
    }
    return null;
  }

  String? getIdentityUserIdFromToken(String token) {
    if (token.isNotEmpty) {
      final Map<String, dynamic>? decodedToken = decodeToken(token);
      return decodedToken?['Id'] as String?;
    }
    return null;
  }
}