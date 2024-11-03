import 'package:flutter/material.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/api/article.dart' as article_api;

class HomeProvider extends ChangeNotifier {
  final List<Article> _articles = [];

  List<Article> get articles => _articles;

  getLatestArticles() async {
    Result<List<Article>> articlesResult = await article_api.Article.getLatest();
    if (!articlesResult.success) {
      debugPrint(articlesResult.message);
      return;
    }
    _articles.clear();
    _articles.addAll(articlesResult.data);
    notifyListeners();
  }
}
