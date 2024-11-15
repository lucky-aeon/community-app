import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiBase {
  static const int _prefixLen = '/api/community'.length;
  static const String baseUrl = 'https://code.xhyovo.cn/api/community';
  static String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6MTMsIk5hbWUiOiJ4aHkzMGM1OTljOS1hMGExLTQ0ZTMtODUzYi0zYTkzYWQwODJiOGIiLCJzdWIiOiJUb2tlbiIsImV4cCI6MTczMjQzMzIwOSwiaWF0IjoxNzI5ODQxMjA5fQ.ougazhk2I4HDqHTTCAep-KP-9cR3iY10tuLS3QExVKU';


static String checkPrefix(String path) {
  if (path.startsWith('/api/community')) {
    return path.substring(_prefixLen);
  }
  return path;

}

static String getUrl(String path) {
  return '$baseUrl${checkPrefix(path)}';
}

static Future<http.Response> getNoJson(String path) async {
  var url = Uri.parse('$baseUrl${checkPrefix(path)}');
  return await http.get(url, headers: {
    'Authorization': token,
  });
}

  static Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? params}) async {
    var url = Uri.parse('$baseUrl$path');
    if (params != null) {
      url = url.replace(queryParameters: params.map((key, value) => MapEntry(key, value.toString())),);
    }
    var response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? params}) async {
    var url = Uri.parse('$baseUrl$path');
    var response = await http.post(url, body: json.encode(params, ), headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class Result<E> {
  final int code;
  final String message;
  final E data;

  Result(this.code, this.message, this.data);

  bool get success => code == 200 || code == 0;
}