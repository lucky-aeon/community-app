import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/notification.dart';

class NotificationApi {
  // 获取消息列表
  static Future<ApiResponse<List<NotificationModel>>> getNotifications({
    required int type,
    bool unreadOnly = false,
  }) async {
    final Map<String, dynamic> queryParams = {
      'type': type,
      if (unreadOnly) 'state': 1,
    };

    var response = await ApiBase.get('/message', params: queryParams);
    return ApiResponse(
      success: response['ok'],
      message: response['msg'],
      data: response['ok'] && response['data'] != null 
          ? List<NotificationModel>.from(
              response['data']['data'].map((e) => NotificationModel.fromJson(e)))
          : [],
    );
  }

  // 标记消息为已读
  static Future<ApiResponse<void>> markAsRead(int notificationId) async {
    var response = await ApiBase.post('/notifications/$notificationId/read');
    return ApiResponse(
      success: response['ok'],
      message: response['msg'],
    );
  }

  // 标记所有消息为已读
  static Future<ApiResponse<void>> markAllAsRead() async {
    var response = await ApiBase.post('/notifications/read-all');
    return ApiResponse(
      success: response['ok'],
      message: response['msg'],
    );
  }

  // 删除消息
  static Future<ApiResponse<void>> deleteNotification(int notificationId) async {
    var response = await ApiBase.delete('/notifications/$notificationId');
    return ApiResponse(
      success: response['ok'],
      message: response['msg'],
    );
  }

  // 获取未读消息数量
  static Future<ApiResponse<int>> getUnreadCount() async {
    var response = await ApiBase.get('/message/unReader/count');
    if (!response['ok']) {
      return ApiResponse(success: false, message: response['msg']);
    }

    return ApiResponse(
      success: true,
      data: response['data'] as int,
    );
  }
}

// API 响应模型
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
  });
} 