import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiBase {
  static const int _prefixLen = '/api/community'.length;
  static const String baseUrl = 'https://code.xhyovo.cn/api/community';
  static String token = '';

  // ignore: constant_identifier_names
  static const String AuthorizationKey = "Authorization";
  static String checkPrefix(String path) {
    if (path.startsWith('/api/community')) {
      return path.substring(_prefixLen);
    }
    return path;
  }

  static String getUrl(String path) {
    return '$baseUrl${checkPrefix(path)}';
  }

  static String getUrlByQueryToken(String path,
      {Map<String, dynamic>? queryParameters}) {
    var url = Uri.parse('$baseUrl${checkPrefix(path)}');

    // 添加新的查询参数
    if (queryParameters != null) {
      queryParameters[AuthorizationKey] = token;
    } else {
      queryParameters = {AuthorizationKey: token};
    }

    // 合并原有查询参数和新查询参数
    Map<String, dynamic> mergedQueryParameters = {};
    if (url.hasQuery) {
      mergedQueryParameters.addAll(url.queryParameters);
    }
    mergedQueryParameters.addAll(queryParameters);

    // 生成包含新旧查询参数的URL
    url = url.replace(queryParameters: mergedQueryParameters);

    return url.toString();
  }

  static Future<http.Response> getNoJson(String path) async {
    var url = Uri.parse('$baseUrl${checkPrefix(path)}');
    return await http.get(url, headers: {
      AuthorizationKey: token,
    });
  }

  static Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? params}) async {
    var url = Uri.parse('$baseUrl$path');
    if (params != null) {
      url = url.replace(
        queryParameters:
            params.map((key, value) => MapEntry(key, value.toString())),
      );
    }
    var response = await http.get(url, headers: {AuthorizationKey: token});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> post(String path,
      {Map<String, dynamic>? params}) async {
    var url = Uri.parse('$baseUrl$path');
    var response = await http.post(url,
        body: json.encode(
          params,
        ),
        headers: {'Content-Type': 'application/json', AuthorizationKey: token});
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
