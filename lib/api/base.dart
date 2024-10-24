import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiBase {
  static const String baseUrl = 'https://code.xhyovo.cn/api/community';

  static Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? params}) async {
    var url = Uri.parse('$baseUrl$path');
    if (params != null) {
      url = url.replace(queryParameters: params);
    }
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? params}) async {
    var url = Uri.parse('$baseUrl$path');
    var response = await http.post(url, body: json.encode(params, ));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
