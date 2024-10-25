import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart' as article_model;

class Article {
  // get articles by latest
  static Future<Result> getLatest() async {
    try {
      var response = await ApiBase.get('/articles/latest');
      if (!response['ok']) {
        throw Exception(response['msg']);
      }
      return Result(
          200,
          'success',
          response['data'] = response['data']
              .map((e) => article_model.Article.fromJson(e))
              .toList());
    } catch (e) {
      return Result(500, e.toString(), null);
    }
  }
}
