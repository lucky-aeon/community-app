import 'package:flutter/material.dart';
import 'package:lucky_community/api/api.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/classify.dart' as classify_model;

class CommunityProvider extends ChangeNotifier {
  List<classify_model.Classify> _classifyList = [];

  List<classify_model.Classify> get classifyList => _classifyList;

  getArticlesClassifys() async {
    try {
      Result<List<classify_model.Classify>> res =
          await Api.getClassify().get(2);
      if (!res.success) {
        return;
      }
      _classifyList = res.data;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
