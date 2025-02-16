import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/api/api.dart';

class ArticleProvider extends ChangeNotifier {
  final lg = Logger('ArticleProvider');
  late Article currentArticle;
  Future<Article?> getArticleDetail(int id) async {
    Result<Article?> res = await Api.getArticle().getDetail(id);
    if (res.success) {
      currentArticle = res.data!;
      return currentArticle;
    }
    return null;
  }

  Future<bool> toggleLike(int articleId) async {
    try {
      // TODO: 调用后端 API 进行点赞/取消点赞
      // final response = await http.post('/api/articles/$articleId/like');
      // return response.statusCode == 200;
      return true;
    } catch (e) {
      lg.severe('Toggle like failed: $e');
      return false;
    }
  }

  Future<bool> toggleCollect(int articleId) async {
    try {
      // TODO: 调用后端 API 进行收藏/取消收藏
      // final response = await http.post('/api/articles/$articleId/collect');
      // return response.statusCode == 200;
      return true;
    } catch (e) {
      lg.severe('Toggle collect failed: $e');
      return false;
    }
  }
}
