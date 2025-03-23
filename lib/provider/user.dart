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

  bool isLogin() {
    return _userInfo != null;
  }

  Future<void> updateNickname(String newNickname) async {
    if (!isLogin()) {
      debugPrint('User info is null');
      throw Exception('用户信息为空');
    }
    if (newNickname == _userInfo!.name) {
      return;
    }
    try {
      var result = await UserApi.updateUserInfo(name: newNickname);
      if (result.success) {
        _userInfo!.name = newNickname;
        notifyListeners();
      } else {
        throw Exception(result.message);
      }
    } catch (e) {
      debugPrint('Error updating nickname: $e');
      throw Exception(e.toString());
    }
  }

  Future<int> toggleSubscribe() async {
    if (!isLogin()) {
      debugPrint('User info is null');
      throw Exception('用户信息为空');
    }
    try {
      var newSub = _userInfo!.subscribe == 1 ? 0 : 1;
      var result = await UserApi.updateUserInfo(subscribe: newSub, name: _userInfo!.name);
      if (result.success) {
        _userInfo!.subscribe = newSub;
        notifyListeners();
        return newSub;
      } else {
        throw Exception(result.message);
      }
    } catch (e) {
      debugPrint('Error toggling subscribe: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> updatePassword(ChangePassword body) async {
    if (!isLogin()) {
      debugPrint('User info is null');
      throw Exception('用户信息为空');
    }
    if (!body.validate()) {
      throw Exception('密码格式不正确');
    }
    try {
      var result = await UserApi.changePassword(body);
      if (result.success) {
        return;
      } else {
        debugPrint('Error updating password: ${result.message}');
        throw Exception(result.message);
      }
    } catch (e) {
      debugPrint('Error updating password: $e');
      throw Exception(e.toString());
    }
  }
}
