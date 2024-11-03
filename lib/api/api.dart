import 'package:lucky_community/api/article.dart';
import 'package:lucky_community/api/classify.dart';

class Api {
  static Article getArticle() {
    return Article();
  }
  static Classify getClassify() {
    return Classify();
  }
}
