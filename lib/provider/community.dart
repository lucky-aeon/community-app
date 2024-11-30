import 'package:flutter/material.dart';
import 'package:lucky_community/api/api.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/model/classify.dart' as classify_model;

class CommunityProvider extends ChangeNotifier {
  int currentParentId = 2;
  int currentClassifyId = 0;
  List<classify_model.Classify> subCategories = [];
  List<Article> currentClassifyArticles = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  static const int pageSize = 10;
  int currentSortId = 1;

  final List<classify_model.Classify> parentCategories = [
    classify_model.Classify(id: 2, title: '文章'),
    classify_model.Classify(id: 1, title: '问答'),
    classify_model.Classify(id: 3, title: '帮助'),
  ];

  void resetPagination() {
    currentPage = 1;
    hasMore = true;
    currentClassifyArticles = [];
  }

  void setCurrentParentId(int id) async {
    currentParentId = id;
    resetPagination();
    notifyListeners();

    await getArticlesClassifys(id);
    
    if (subCategories.isNotEmpty) {
      currentClassifyId = subCategories[0].id;
      await getCurrentListDataByArticle();
    }
  }

  void setCurrentClassify(int id) {
    currentClassifyId = id;
    resetPagination();
    notifyListeners();
  }

  void setCurrentSort(int sortId) {
    if (currentSortId != sortId) {
      currentSortId = sortId;
      resetPagination();
      getCurrentListDataByArticle();
    }
  }

  Future<void> getCurrentListDataByArticle({bool loadMore = false}) async {
    if (isLoading || (!loadMore && currentClassifyArticles.isNotEmpty)) return;
    if (loadMore && !hasMore) return;

    isLoading = true;
    if (!loadMore) {
      currentPage = 1;
      hasMore = true;
    }
    notifyListeners();

    try {
      var result = await Api.getArticle().getPageList(
        currentClassifyId,
        currentPage,
        pageSize,
        sortType: currentSortId,
      );
      
      if (result.success) {
        if (loadMore) {
          currentClassifyArticles.addAll(result.data);
        } else {
          currentClassifyArticles = result.data;
        }
        
        hasMore = result.data.length >= pageSize;
        if (hasMore) currentPage++;
      } else {
        if (!loadMore) currentClassifyArticles = [];
      }
    } catch (e) {
      print('Error loading articles: $e');
      if (!loadMore) currentClassifyArticles = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> init() async {
    resetPagination();
    await getArticlesClassifys(currentParentId);
    if (subCategories.isNotEmpty) {
      currentClassifyId = subCategories[0].id;
    }
    await getCurrentListDataByArticle();
  }

  Future<List<classify_model.Classify>> getArticlesClassifys(int parentId) async {
    Result<List<classify_model.Classify>> res =
        await Api.getClassify().get(parentId);
    if (res.success) {
      subCategories = [
        classify_model.Classify(id: parentId, title: '全部'),
        ...res.data,
      ];
      if (currentClassifyId == 0) {
        currentClassifyId = parentId;
      }
      notifyListeners();
    }
    return subCategories;
  }
}
