import 'package:flutter/material.dart';
import 'package:lucky_community/api/api.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/api/article.dart' as article_api;
import 'package:lucky_community/model/course.dart';

class HomeProvider extends ChangeNotifier {
  final List<Article> _articles = [];
  final List<Course> _courses = [];

  List<Article> get articles => _articles;
  List<Course> get courses => _courses;

  getLatestArticles() async {
    Result<List<Article>> articlesResult = await article_api.Article.getLatest();
    if (!articlesResult.success) {
      return;
    }
    _articles.clear();
    _articles.addAll(articlesResult.data);
    notifyListeners();
  }

  getSectionNews() async {
    List<Course> courses = await Api.getCourse().getSectionNews();
    _courses.clear();
    _courses.addAll(courses);
    notifyListeners();
  }
}
