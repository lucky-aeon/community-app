import 'package:lucky_community/api/base.dart';

class Auth {
  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return null;
    }
    try {
      return ApiBase.post("/login",
          params: {'account': username, 'password': password, 'read': true});
    } catch (e) {
      return null;
    }
  }
}
