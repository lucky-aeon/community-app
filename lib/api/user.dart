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
} 