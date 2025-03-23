/* 课程
 */

import 'package:flutter/foundation.dart';

class Course {
  int id;
  String title;
  String desc;
  String technology;
  List<String> technologys;
  String url;
  int userId;
  int money;
  String cover;
  int score;
  int state;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  dynamic sections;
  int views;

  Course({
    required this.id,
    required this.title,
    required this.desc,
    required this.technology,
    required this.technologys,
    required this.url,
    required this.userId,
    required this.money,
    required this.cover,
    required this.score,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.sections,
    required this.views,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    return Course(
      id: json['id'],
      title: json['title'] ?? '暂无标题',
      desc: json['desc'] ?? '暂无描述',
      technology: json['technology'] ?? '暂无技术',
      technologys: List<String>.from(json['technologys'] ?? []),
      url: json['url'] ?? '暂无链接',
      userId: json['userId'] ?? 0,
      money: json['money'] ?? 0,
      cover: json['cover'] != null && json['cover'].toString().length > 5
          ? "/file/singUrl?fileKey=${json['cover']}"
          : '',
      score: json['score'] ?? 0,
      state: json['state'] ?? 0,
      createdAt: json['createdAt'] ?? '暂无创建时间',
      updatedAt: json['updatedAt'] ?? '暂无更新时间',
      deletedAt: json['deletedAt'] ?? '暂无删除时间',
      sections: json['sections'] ?? [],
      views: json['views'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'technology': technology,
      'technologys': technologys,
      'url': url,
      'userId': userId,
      'money': money,
      'cover': cover,
      'score': score,
      'state': state,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'sections': sections,
      'views': views,
    };
  }
}