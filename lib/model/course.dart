/* 课程
 */

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
    return Course(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      technology: json['technology'],
      technologys: List<String>.from(json['technologys']),
      url: json['url'],
      userId: json['userId'],
      money: json['money'],
      cover: json['cover'],
      score: json['score'],
      state: json['state'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      sections: json['sections'],
      views: json['views'],
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