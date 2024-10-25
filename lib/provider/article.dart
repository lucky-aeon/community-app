import 'package:flutter/material.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/api/article.dart' as article_api;

class ArticleListProvider extends ChangeNotifier {
  final List<Article> _articles = [];

  get articles => _articles;

  void getLatestArticles() async {
    Result articlesResult = await article_api.Article.getLatest();
    if (!articlesResult.success) {
      return;
    }
    _articles.clear();
    _articles.addAll(articlesResult.data);
    notifyListeners();
  }
}
