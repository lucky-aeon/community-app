import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/comment.dart';

class CommentApi {
  final lg = Logger('CommentApi');
  // 发布/回复评论
  Future<Result<void>> postComment({
    required String content,
    required int businessId,
    required int businessUserId,
    int? parentId,
    int? rootId,
    int? toUserId,
  }) async {
    try {
      var params = {
        'content': content,
        'businessId': businessId,
        'businessUserId': businessUserId,
        'parentId': parentId ?? 0,
        'tenantId': 0,
      };

      if (rootId != null) params['rootId'] = rootId;
      if (toUserId != null) params['toUserId'] = toUserId;

      var response = await ApiBase.post('/comments/comment', params: params);

      if (!response['ok']) {
        throw Exception(response['msg']);
      }
      return Result(200, 'success', null);
    } catch (e) {
      return Result(500, e.toString(), null);
    }
  }

  // 获取文章评论
  Future<Result<List<Comment>>> getArticleComments(int businessId) async {
    try {
      var response = await ApiBase.get('/comments/byArticleId/$businessId');
      lg.info('API Response: $response');

      if (!response['ok']) {
        throw Exception(response['msg']);
      }

      if (response['data'] == null || response['data']['data'] == null) {
        return Result(200, 'success', []);
      }

      return Result<List<Comment>>(
        200,
        'success',
        List<Comment>.from(
          response['data']['data'].map((x) => Comment.fromJson(x)),
        ),
      );
    } catch (e, stackTrace) {
      lg.severe('Exception in getArticleComments: $e');
      lg.severe('Stack trace: $stackTrace');
      return Result(500, e.toString(), []);
    }
  }

  // 获取根评论下的评论
  Future<Result<List<Comment>>> getRootComments(int rootId) async {
    try {
      var response = await ApiBase.get(
        '/comments/byRootId/$rootId',
        params: {
          'page': '1',
          'limit': '50',
        },
      );

      if (!response['ok']) {
        throw Exception(response['msg']);
      }

      if (response['data'] == null || response['data']['data'] == null) {
        return Result(200, 'success', []);
      }

      return Result<List<Comment>>(
        200,
        'success',
        List<Comment>.from(
          response['data']['data'].map((x) => Comment.fromJson(x)),
        ),
      );
    } catch (e) {
      debugPrint('Error getting root comments: $e');
      return Result(500, e.toString(), []);
    }
  }

  // 删除评论
  Future<Result<void>> deleteComment(int commentId) async {
    try {
      var response = await ApiBase.delete('/comments/$commentId');

      if (!response['ok']) {
        throw Exception(response['msg']);
      }
      return Result(200, 'success', null);
    } catch (e) {
      return Result(500, e.toString(), null);
    }
  }

  // 采纳评论
  Future<Result<void>> adoptComment({
    required int articleId,
    required int commentId,
  }) async {
    try {
      var response = await ApiBase.post('/comments/adoption', params: {
        'articleId': articleId.toString(),
        'CommentId': commentId.toString(),
      });

      if (!response['ok']) {
        throw Exception(response['msg']);
      }
      return Result(200, response['msg'], null);
    } catch (e) {
      return Result(500, e.toString(), null);
    }
  }
}
