class Classify {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int parentId;
  final String title;
  final String desc;
  final bool state;
  final int sort;
  final String articleState;
  final List<String>? articleStates;
  final String flagName;
  final List<Classify>? children;

  Classify({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.parentId,
    required this.title,
    required this.desc,
    required this.state,
    required this.sort,
    required this.articleState,
    this.articleStates,
    required this.flagName,
    this.children,
  });

  factory Classify.fromJson(Map<String, dynamic> json) {
    return Classify(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['DeletedAt'] == "0001-01-01 00:00:00" ? null : DateTime.parse(json['DeletedAt']),
      parentId: json['parentId'],
      title: json['title'],
      desc: json['desc'],
      state: json['state'],
      sort: json['sort'],
      articleState: json['articleState'],
      articleStates: json['articleStates'] != null ? List<String>.from(json['articleStates']) : null,
      flagName: json['flagName'],
      children: json['children'] != null
          ? (json['children'] as List).map((child) => Classify.fromJson(child)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'DeletedAt': deletedAt?.toIso8601String() ?? "0001-01-01 00:00:00",
      'parentId': parentId,
      'title': title,
      'desc': desc,
      'state': state,
      'sort': sort,
      'articleState': articleState,
      'articleStates': articleStates,
      'flagName': flagName,
      'children': children?.map((child) => child.toJson()).toList(),
    };
  }
}
