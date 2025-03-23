class NotificationModel {
  final int id;
  final String content;
  final int from;
  final int to;
  final bool state;
  final int type;
  final int articleId;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.content,
    required this.from,
    required this.to,
    required this.state,
    required this.type,
    required this.articleId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      content: json['content'],
      from: json['from'],
      to: json['to'],
      state: json['state'] == 1,
      type: json['type'],
      articleId: json['articleId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
} 