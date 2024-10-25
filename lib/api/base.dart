import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiBase {
  static const String baseUrl = 'https://code.xhyovo.cn/api/community';
  static String token = '';

  static Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? params}) async {
    var url = Uri.parse('$baseUrl$path');
    if (params != null) {
      url = url.replace(queryParameters: params);
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

class Result {
  final int code;
  final String message;
  final dynamic data;

  Result(this.code, this.message, this.data);

  bool get success => code == 200 || code == 0;
}