import 'package:flutter/material.dart';
import 'package:lucky_community/api/auth.dart';
import 'package:lucky_community/api/base.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _token;
  String? get token => _token;


  Future<void> login(String username, String password) async {
    try {
      final response = await Auth.login(username, password);
      if(response == null) {
        return;
      }
      if (response['ok'] == true) {
        _isLoggedIn = true;
        _errorMessage = null;
        _token = response['data']['token'];
        ApiBase.token = _token??'';
      } else {
        _errorMessage = response['msg'];
        _isLoggedIn = false;
      }
    } catch (error) {
      _errorMessage = 'Login failed. Please try again.';
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}