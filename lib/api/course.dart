import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/course.dart';

class CourseApi {
  Future<Map<String, dynamic>> getCourseList() async {
    return ApiBase.get('/courses');
  }


  // 获取最新课程
  Future<List<Course>> getSectionNews() async {
    var response = await ApiBase.get('/courses/section/newest');
    if (!response['ok']) {
      return [];
    }
    if (response['data'] == null) {
      return [];
    }
    return List<Course>.from(response['data'].map((item) => Course.fromJson(item)));
  }
}
