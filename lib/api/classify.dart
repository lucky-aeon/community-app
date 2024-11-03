import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/classify.dart' as classify_model;

class Classify {
  // https://code.xhyovo.cn/api/community/classfiys?parentId=2
  // get classifys
  Future<Result<List<classify_model.Classify>>> get(int parentId) async {
    try {
      var response = await ApiBase.get('/classfiys', params: {'parentId': parentId});
      if (!response['ok']) {
        throw Exception(response['msg']);
      }
      return Result<List<classify_model.Classify>>(
          200,
          'success',
          List<classify_model.Classify>.from(
              response['data'].map((e) => classify_model.Classify.fromJson(e))));
    } catch (e) {
      return Result(500, e.toString(), []);
    }
  }
}