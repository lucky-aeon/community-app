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
      currentArticle.content = res.data!.content?.replaceAll('/api/community/file/singUrl?fileKey=13/1730426346575', 'https://oss.xhyovo.cn/13%2F1730426346575?Expires=1730643829&OSSAccessKeyId=LTAI5tHthVoXiFMEbmHpsW4w&Signature=7Lf5k1fGl6P%2BhZQlPKblXcgHnV0%3D');
      return currentArticle;
    }
    return null;
  }
}
