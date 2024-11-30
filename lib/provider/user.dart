import 'package:flutter/material.dart';
import 'package:lucky_community/api/user.dart';
import 'package:lucky_community/model/user.dart';

class UserProvider with ChangeNotifier {
  UserInfo? _userInfo;
  UserInfo? get userInfo => _userInfo;

  int? get currentUserId => _userInfo?.id;

  Future<void> fetchUserInfo() async {
    try {
      var result = await UserApi.getUserInfo();
      if (result.success && result.data != null) {
        _userInfo = result.data;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }
}
