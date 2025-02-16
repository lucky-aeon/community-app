import 'package:lucky_community/model/article_type.dart';
import 'package:lucky_community/model/user.dart';

class Article {
  final int id;
  String title;
  int? state;
  int? like;
  int? comments;
  String? cover;
  String? abstract;
  String? tags;
  ArticleType? type;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? stateName;
  int? topNumber;
  String? content;

  Article({
    required this.id,
    required this.title,
    this.state,
    this.like,
    this.comments,
    this.cover,
    this.abstract,
    this.tags,
    this.type,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.stateName,
    this.topNumber,
    this.content,
  });

  String get userName => user?.name ?? '';

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      state: json['state'] ?? 0,
      like: json['like'] ?? 0,
      comments: json['comments'] ?? 0,
      cover: json['cover'] == null || json['cover'].toString().length > 5
          ? "/file/singUrl?fileKey=${json['cover']}"
          : '',
      abstract: json['abstract'] ?? '',
      // tags: json['tags'] ?? '',
      type: json['type'] != null ? ArticleType.fromJson(json['type']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      stateName: json['stateName'] ?? 'Unknown',
      topNumber: json['topNumber'] ?? 0,
      content: json['content'] ?? '',
    );
  }
}
