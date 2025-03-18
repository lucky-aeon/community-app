import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucky_community/provider/user.dart';

class AppSettingPage extends StatefulWidget {
  const AppSettingPage({super.key});

  @override
  State<AppSettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<AppSettingPage> {
  late UserProvider _userProvider;
  bool notificationEnabled = true;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  // 显示修改昵称对话框
  Future<String?> _showNicknameDialog() async {
    final TextEditingController controller = TextEditingController(
      text: _userProvider.userInfo?.name
    );

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('修改昵称'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '请输入新昵称',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            maxLength: 20,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final newNickname = controller.text.trim();
                if (newNickname.isNotEmpty) {
                  Navigator.of(context).pop(newNickname);
                }
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  // 显示加载对话框
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // 显示提示消息
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 处理昵称更新
  Future<void> _handleNicknameUpdate() async {
    final result = await _showNicknameDialog();
    if (!mounted) return;
    final navi =  Navigator.of(context);
    if (result != null && result.isNotEmpty) {
      try {
        _showLoadingDialog();
        await _userProvider.updateNickname(result);
        navi.pop(); // 关闭加载对话框
        _showMessage('昵称修改成功');
      } catch (e) {
        navi.pop(); // 关闭加载对话框
        _showMessage('修改失败：${e.toString()}', isError: true);
      }
    }
  }

  // 处理通知开关
  Future<void> _handleNotificationToggle(bool value) async {
    setState(() {
      notificationEnabled = value;
    });
    // TODO: 实现保存通知设置的逻辑
  }

  // 处理密码修改
  void _handlePasswordChange() {
    // TODO: 实现密码修改页面导航
  }

  // 构建设置项
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: trailing,
          onTap: onTap,
        ),
        const Divider(height: 0.01, color: Color.fromARGB(255, 230, 230, 230),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.white,  
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Column(
            children: [
              _buildSettingItem(
                icon: Icons.person_outline,
                title: '昵称',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userProvider.userInfo?.name ?? '未设置',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: _handleNicknameUpdate,
              ),
              _buildSettingItem(
                icon: Icons.notifications_outlined,
                title: '订阅App消息',
                trailing: Switch(
                  value: notificationEnabled,
                  onChanged: _handleNotificationToggle,
                ),
              ),
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: '修改密码',
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: _handlePasswordChange,
              ),
            ],
          );
        },
      ),
    );
  }
}
