class Comment {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int parentId;
  final int rootId;
  final String content;
  final int fromUserId;
  final int? toUserId;
  final int businessId;
  final int tenantId;
  final List<Comment>? childComments;
  final int childCommentNumber;
  final String fromUserName;
  final String? toUserName;
  final String articleTitle;
  final String? fromUserAvatar;
  final bool? adoptionState;

  Comment({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.parentId,
    required this.rootId,
    required this.content,
    required this.fromUserId,
    this.toUserId,
    required this.businessId,
    required this.tenantId,
    this.childComments,
    required this.childCommentNumber,
    required this.fromUserName,
    this.toUserName,
    required this.articleTitle,
    this.fromUserAvatar,
    this.adoptionState,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    try {
      return Comment(
        id: json['id'] ?? 0,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
        deletedAt: json['DeletedAt'] != null ? DateTime.parse(json['DeletedAt']) : null,
        parentId: json['parentId'] ?? 0,
        rootId: json['rootId'] ?? 0,
        content: json['content'] ?? '',
        fromUserId: json['FromUserId'] ?? 0,
        toUserId: json['toUserId'],
        businessId: json['businessId'] ?? 0,
        tenantId: json['tenantId'] ?? 0,
        childComments: json['childComments'] != null
            ? List<Comment>.from(
                json['childComments'].map((x) => Comment.fromJson(x)))
            : null,
        childCommentNumber: json['childCommentNumber'] ?? 0,
        fromUserName: json['fromUserName'] ?? '',
        toUserName: json['toUserName'],
        articleTitle: json['articleTitle'] ?? '',
        fromUserAvatar: json['fromUserAvatar']== null || json['fromUserAvatar'].toString().length >5? "/file/singUrl?fileKey=${json['fromUserAvatar']}" : '',
        adoptionState: json['adoptionState'],
      );
    } catch (e, stackTrace) {
      print('Error parsing comment: $e');
      print('JSON data: $json');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
} 