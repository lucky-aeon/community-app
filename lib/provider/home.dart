import 'package:flutter/material.dart';
import 'package:lucky_community/api/api.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/api/article.dart' as article_api;
import 'package:lucky_community/model/course.dart';

class HomeProvider extends ChangeNotifier {
  final List<Article> _articles = [];
  final List<Course> _courses = [];
  final List<Course> _coursesList = [];

  List<Article> get articles => _articles;
  List<Course> get courses => _courses;
  List<Course> get coursesList => _coursesList;
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

  getCourseList() async {
    Map<String, dynamic> courses = await Api.getCourse().getCourseList();
    if (!courses['ok']) {
      return;
    }
    _coursesList.clear();
    _coursesList.addAll(List<Course>.from(courses['data']['list'].map((item) => Course.fromJson(item))));
    notifyListeners();
  }
}
