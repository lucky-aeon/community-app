import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/user.dart';

class UserApi {
  static Future<Result<UserInfo?>> getUserInfo([int? userId]) async {
    try {
      var response = await ApiBase.get(
        '/user/info',
        params: userId != null ? {'id': userId.toString()} : null,
      );

      if (!response['ok']) {
        throw Exception(response['msg']);
      }

      return Result(
        200,
        'success',
        UserInfo.fromJson(response['data']),
      );
    } catch (e) {
      return Result(500, e.toString(), null);
    }
  }

  static Future<Result> updateUserInfo(
      {String? name, String? avatar, String? desc, int? subscribe}) async {
    try {
      var response = await ApiBase.post('/user/edit/info', params: {
        'name': name,
        'avatar': avatar,
        'desc': desc,
        'subscribe': subscribe,
      });

      if (!response['ok']) {
        throw Exception(response['msg']);
      }

      return Result(200, 'success', null);
    } catch (e) {
      return Result(500, e.toString(), null);
    }
  }

  // change password: /user/edit/pass
  static Future<Result> changePassword(ChangePassword body) async {
    try {
      var response = await ApiBase.post('/user/edit/pass', params: {
        'oldPassword': body.oldPassword,
        'newPassword': body.newPassword,
        'confirmPassword': body.confirmPassword,
      });

      if (!response['ok']) {
        throw Exception(response['msg']);
      }
      return Result(200, 'success', null);
    } catch (e) {
      return Result(500, e.toString(), null);
    }
  }
}
