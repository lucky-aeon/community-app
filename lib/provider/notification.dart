import 'package:flutter/material.dart';
import 'package:lucky_community/api/notification.dart';
import 'package:lucky_community/model/notification.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;
  
  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  // 获取指定类型的消息列表
  Future<void> fetchNotifications(int type, {bool unreadOnly = false}) async {
    try {
      var result = await NotificationApi.getNotifications(
        type: type,
        unreadOnly: unreadOnly,
      );
      if (result.success && result.data != null) {
        _notifications = result.data!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    }
  }

  // 在通知页面切换标签时调用
  Future<void> fetchNotificationsByType(int type) async {
    await fetchNotifications(type);
  }

  // 获取未读消息数量
  Future<void> fetchUnreadCount() async {
    try {
      var result = await NotificationApi.getUnreadCount();
      if (result.success && result.data != null) {
        _unreadCount = result.data!;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching unread count: $e');
    }
  }

  // 在标记已读后更新未读数量
  void _decrementUnreadCount() {
    if (_unreadCount > 0) {
      _unreadCount--;
      notifyListeners();
    }
  }

  // 修改现有的标记已读方法
  Future<void> markAsRead(int notificationId) async {
    try {
      var result = await NotificationApi.markAsRead(notificationId);
      if (result.success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1 && !_notifications[index].state) {
          _notifications[index] = NotificationModel(
            id: _notifications[index].id,
            content: _notifications[index].content,
            from: _notifications[index].from,
            to: _notifications[index].to,
            state: true,
            type: _notifications[index].type,
            articleId: _notifications[index].articleId,
            createdAt: _notifications[index].createdAt,
          );
          _decrementUnreadCount();
        }
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  // 修改现有的全部标记已读方法
  Future<void> markAllAsRead() async {
    try {
      var result = await NotificationApi.markAllAsRead();
      if (result.success) {
        _notifications = _notifications.map((n) => NotificationModel(
          id: n.id,
          content: n.content,
          from: n.from,
          to: n.to,
          state: true,
          type: n.type,
          articleId: n.articleId,
          createdAt: n.createdAt,
        )).toList();
        _unreadCount = 0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }
} 