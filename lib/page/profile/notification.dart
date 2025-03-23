import 'package:flutter/material.dart';
import 'package:lucky_community/model/notification.dart';
import 'package:lucky_community/provider/notification.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // 默认加载通知类型的消息
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });

    // 监听标签切换
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadNotifications();
      }
    });
  }

  // 根据当前tab加载对应类型的消息
  void _loadNotifications() {
    // tab index + 1 对应消息类型（1: 通知, 2: @我）
    final messageType = _tabController.index + 1;
    context.read<NotificationProvider>().fetchNotifications(messageType);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 构建消息列表项
  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 230, 230, 230),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 未读标记
          if (!notification.state)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, right: 8),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: notification.state ? Colors.grey[600] : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTime(notification.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 格式化时间
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          '暂无消息',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadNotifications(); // 修改这里，使用统一的加载方法
      },
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationItem(notifications[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息中心'),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '通知'),
            Tab(text: '@我'),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          // 不需要在这里过滤消息类型，因为API已经返回对应类型的消息
          return TabBarView(
            controller: _tabController,
            children: [
              // 通知列表
              _buildNotificationList(provider.notifications),
              // @我列表
              _buildNotificationList(provider.notifications),
            ],
          );
        },
      ),
    );
  }
}
