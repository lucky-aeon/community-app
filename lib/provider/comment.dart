import 'package:flutter/material.dart';
import 'package:lucky_community/api/api.dart';
import 'package:lucky_community/model/comment.dart';

class CommentProvider extends ChangeNotifier {
  List<Comment> articleComments = [];  // 文章评论列表
  List<Comment> replyComments = [];    // 评论的回复列表
  bool isLoading = false;
  int? currentBusinessId;
  int? currentBusinessUserId;
  Comment? replyToComment;
  String? replyHint;
  Comment? rootComment;

  void setReplyTo(Comment? comment) {
    replyToComment = comment;
    replyHint = comment != null ? '回复 ${comment.fromUserName}' : null;
    notifyListeners();
  }

  void clearReplyTo() {
    replyToComment = null;
    replyHint = null;
    notifyListeners();
  }

  void setRootComment(Comment comment) {
    rootComment = comment;
    notifyListeners();
  }

  Future<bool> postComment({
    required String content,
    required bool refreshChild,
    int? parentId,
    int? rootId,
    int? toUserId,
  }) async {
    if (currentBusinessUserId == null) return false;

    try {
      var result = await Api.getComment().postComment(
        content: content,
        businessId: currentBusinessId!,
        businessUserId: currentBusinessUserId!,
        parentId: parentId,
        rootId: rootId,
        toUserId: toUserId,
      );

      if (result.success) {
        clearReplyTo();
        // 在文章详情页面下，直接刷新文章评论列表
        if (refreshChild) {
          await getArticleComments();
        } else {
          await getCommentReplies(rootComment!.id);
        }
        return true;
      } else {
        print('Failed to post comment: ${result.message}');
        return false;
      }
    } catch (e) {
      print('Error posting comment: $e');
      return false;
    }
  }

  // 获取文章评论列表
  Future<void> getArticleComments() async {
    if (currentBusinessId == null) return;
    
    isLoading = true;
    notifyListeners();

    try {
      var result = await Api.getComment().getArticleComments(currentBusinessId!);
      if (result.success) {
        articleComments = result.data;
      } else {
        print('Failed to load comments: ${result.message}');
        articleComments = [];
      }
    } catch (e) {
      print('Error loading comments: $e');
      articleComments = [];
    }

    isLoading = false;
    notifyListeners();
  }

  // 获取评论的回复列表
  Future<void> getCommentReplies(int rootId) async {
    isLoading = true;
    notifyListeners();

    try {
      debugPrint('Getting replies for comment: $rootId');
      var result = await Api.getComment().getRootComments(rootId);
      if (result.success) {
        replyComments = result.data;
        debugPrint('Got ${replyComments.length} replies');
      } else {
        debugPrint('Failed to load replies: ${result.message}');
        replyComments = [];
      }
    } catch (e) {
      debugPrint('Error loading replies: $e');
      replyComments = [];
    }

    isLoading = false;
    notifyListeners();
  }

  // 初始化文章评论
  Future<void> initArticleComments(int businessId, int businessUserId) async {
    currentBusinessId = businessId;
    currentBusinessUserId = businessUserId;
    await getArticleComments();
  }

  // 初始化评论详情
  Future<void> initCommentDetail(Comment comment) async {
    currentBusinessId = comment.businessId;
    currentBusinessUserId = comment.fromUserId;
    setRootComment(comment);
    // 确保是根评论ID
    final rootId = comment.rootId == 0 ? comment.id : comment.rootId;
    await getCommentReplies(rootId);
  }

  // ... 其他方法保持不变 ...

// 删除评论
  Future<bool> deleteComment(int commentId, {bool isChild = false}) async {
    try {
      var result = await Api.getComment().deleteComment(commentId);
      if (result.success) {
        // 根据是否是子评论决定刷新哪个列表
        if (isChild) {
          await getCommentReplies(rootComment!.id);
        } else {
          await getArticleComments();
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting comment: $e');
      return false;
    }
  }
} 