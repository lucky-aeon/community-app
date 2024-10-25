import 'package:lucky_community/model/article_type.dart';
import 'package:lucky_community/model/user.dart';

class Article {
  final int id;
  final String title;
  final int state;
  final int like;
  final int comments;
  final String cover;
  final String abstractContent;
  final String tags;
  final ArticleType type;
  final User user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String stateName;
  final int topNumber;

  Article({
    required this.id,
    required this.title,
    required this.state,
    required this.like,
    required this.comments,
    required this.cover,
    required this.abstractContent,
    required this.tags,
    required this.type,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.stateName,
    required this.topNumber,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      state: json['state'],
      like: json['like'],
      comments: json['comments'],
      cover: json['cover'],
      abstractContent: json['abstractContent'],
      tags: json['tags'],
      type: ArticleType.fromJson(json['type']),
      user: User.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      stateName: json['stateName'],
      topNumber: json['topNumber'],
    );
  }
}
