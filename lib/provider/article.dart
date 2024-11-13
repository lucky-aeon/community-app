import 'package:flutter/material.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/api/api.dart';

class ArticleProvider extends ChangeNotifier {
  late Article currentArticle;
  Future<Article?> getArticleDetail(int id) async {
    Result<Article?> res = await Api.getArticle().getDetail(id);
    if (res.success) {
      currentArticle = res.data!;
      return currentArticle;
    }
    return null;
  }
}
