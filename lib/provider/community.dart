import 'package:flutter/material.dart';
import 'package:lucky_community/api/api.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/model/classify.dart' as classify_model;

class CommunityProvider extends ChangeNotifier {
  // 分类列表
  List<classify_model.Classify> _classifyList = [];
  List<classify_model.Classify> get classifyList => _classifyList;

  // 文章列表，根据分类id获取
  List<Article> _currentClassifyArticles = [];
  List<Article> get currentClassifyArticles => _currentClassifyArticles;

  // 分类id
  int _currentClassifyId = 2;
  int get currentClassifyId => _currentClassifyId;

  Future<List<classify_model.Classify>> getArticlesClassifys(
      int parentId) async {
    try {
      Result<List<classify_model.Classify>> res =
          await Api.getClassify().get(parentId);
      if (!res.success) {
        return [];
      }
      _classifyList = res.data;
      notifyListeners();
      return _classifyList;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  // 获取当前分类下的文章列表
  getCurrentListDataByArticle() async {
    try {
      Result<List<Article>> result =
          await Api.getArticle().getPageList(_currentClassifyId, 1, 10);
      if (!result.success) {
        _currentClassifyArticles = [];
        return;
      }
      _currentClassifyArticles = result.data;
    } catch (e) {
      _currentClassifyArticles = [];
    }
    notifyListeners();
  }

  setCurrentClassify(int classifyId) {
    if (_currentClassifyId == classifyId) {
      return;
    }
    if(classifyId < 0) {
      return;
    }
    _currentClassifyId = classifyId;
    notifyListeners();
  }
}
