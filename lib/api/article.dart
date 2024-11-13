import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart' as article_model;

class Article {
  // get articles by latest
  static Future<Result<List<article_model.Article>>> getLatest() async {
    try {
      var response = await ApiBase.get('/articles/latest');
      if (!response['ok']) {
        throw Exception(response['msg']);
      }
      return Result<List<article_model.Article>>(
          200,
          'success',
          List<article_model.Article>.from(
              response['data'].map((e) => article_model.Article.fromJson(e))));
    } catch (e) {
      return Result(500, e.toString(), []);
    }
  }

  Future<Result<article_model.Article?>> getDetail(int articleId) async {
    try {
      var response = await ApiBase.get('/articles/$articleId');
      if (!response['ok']) {
        throw Exception(response['msg']);
      }
      return Result<article_model.Article>(
          200, 'success', article_model.Article.fromJson(response['data']));
    } catch (e) {
      return Result(500, e.toString(), null);
    }
  }

  Future<Result<List<article_model.Article>>> getPageList(
      int classifyId, int page, int pageSize, {String? searchTitle, int? userId}) async {
    try {
      var response = await ApiBase.get('/articles/list', params: {
        'typeId': classifyId,
        'page': page,
        'limit': pageSize,
      });
      if (!response['ok']) {
        throw Exception(response['msg']);
      }
      return Result<List<article_model.Article>>(
          200,
          'success',
          List<article_model.Article>.from(
              response['data']['list'].map((e) => article_model.Article.fromJson(e))));
    } catch (e) {
      return Result(500, e.toString(), []);
    }
  }
}
