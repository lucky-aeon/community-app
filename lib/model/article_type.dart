class ArticleType {
  final int id;
  final String flag;
  final String title;

  ArticleType({
    required this.id,
    required this.flag,
    required this.title,
  });

  factory ArticleType.fromJson(Map<String, dynamic> json) {
    return ArticleType(
      id: json['id'],
      flag: json['flag'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flag': flag,
      'title': title,
    };
  }
}