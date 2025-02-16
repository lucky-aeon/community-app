import 'package:lucky_community/api/article.dart';
import 'package:lucky_community/api/classify.dart';
import 'package:lucky_community/api/comment.dart';
import 'package:lucky_community/api/course.dart';

class Api {
  static Article getArticle() {
    return Article();
  }
  static Classify getClassify() {
    return Classify();
  }
  static CommentApi getComment() {
    return CommentApi();
  }

  static CourseApi getCourse() {
    return CourseApi();
  }
}
