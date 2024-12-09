import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String username = '';
  String password = '';
  bool isLoggedIn = false;

  void login(String inputUsername, String inputPassword) {
    if (inputUsername == 'nani50011' && inputPassword == '12345') {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }
}
