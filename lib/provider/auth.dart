import 'package:flutter/material.dart';
import 'package:lucky_community/api/auth.dart';
import 'package:lucky_community/api/base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTMsIk5hbWUiOiJ4aHlkYzc0ZDE1YS02OWM4LTQ5MDUtYTYyYi01OTUxNzU1NGI1MzMiLCJzdWIiOiJUb2tlbiIsImV4cCI6MTczMjUzMDcyMCwiaWF0IjoxNzI5OTM4NzIwfQ.5AkKrnr5q7Dv4Wg7oDyU-jmw60jVf1z3EOcz93kWkRM";
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
        debugPrint(_token);
        ApiBase.token = _token??'';
        await saveLoginInfo(username, password);
      } else {
        _errorMessage = response['msg'];
        _isLoggedIn = false;
      }
    } catch (error) {
      _errorMessage = 'Login failed. Please try again.';
      debugPrint(error.toString());
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    notifyListeners();
  }

  // 检查是否已登录
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // 保存登录信息
  Future<void> saveLoginInfo(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', true);
  }

  // 自动登录
  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');
    
    if (username != null && password != null) {
      // 调用登录方法
      try {
        await login(username, password);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

} 