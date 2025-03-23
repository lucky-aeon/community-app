import 'package:flutter/material.dart';
import 'package:lucky_community/model/user.dart';
import 'package:lucky_community/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:lucky_community/provider/user.dart';

class AppSettingPage extends StatefulWidget {
  const AppSettingPage({super.key});

  @override
  State<AppSettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<AppSettingPage> {
  late UserProvider _userProvider;
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            '修改昵称',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '请输入新昵称',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            autofocus: true,
            maxLength: 20,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                final newNickname = controller.text.trim();
                if (newNickname.isNotEmpty) {
                  Navigator.of(context).pop(newNickname);
                }
              },
              child: const Text(
                '确定',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 显示修改密码对话框
  Future<ChangePassword?> _showPasswordDialog() async {
    final TextEditingController oldPasswordController = TextEditingController(
      text: "",
    );
    final TextEditingController newPasswordController = TextEditingController(
      text: "",
    );
    final TextEditingController confirmPasswordController = TextEditingController(
      text: "",
    );

    return showDialog<ChangePassword>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            '修改密码',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: oldPasswordController,
                    decoration: const InputDecoration(
                      hintText: '请输入旧密码',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    obscureText: true,
                    autofocus: true,
                    maxLength: 20,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      hintText: '请输入新密码',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    obscureText: true,
                    maxLength: 20,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      hintText: '请确认新密码',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    obscureText: true,
                    maxLength: 20,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                final oldPassword = oldPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();
                final confirmPassword = confirmPasswordController.text.trim();
                if (oldPassword.isNotEmpty && newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
                  Navigator.of(context).pop(ChangePassword(oldPassword: oldPassword, newPassword: newPassword, confirmPassword: confirmPassword));
                }
              },
              child: const Text(
                '确定',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
                SizedBox(height: 12),
                Text(
                  '加载中...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
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
        _showMessage('昵称修改成功');
      } catch (e) {
        _showMessage('修改失败：${e.toString()}', isError: true);
      } finally {
        navi.pop(); // 关闭加载对话框
      }
    }
  }

  // 处理通知开关
  Future<void> _handleNotificationToggle(bool value) async {
    if (!mounted) return;
     final navi = Navigator.of(context);  // 保存 Navigator 引用
    try {
      _showLoadingDialog();
      await _userProvider.toggleSubscribe();
      _showMessage('订阅成功');
    } catch (e) {
      _showMessage('订阅失败：${e.toString()}', isError: true);
    } finally {
      navi.pop(); // 关闭加载对话框
    }
  }

  // 处理密码修改
  Future<void> _handlePasswordChange() async {
    final result = await _showPasswordDialog();
    if (!mounted) return;
    if (result == null) {
      return;
    }

    if (!result.validate()) {
      _showMessage('请检查密码是否正确', isError: true);
      return;
    }

    final navi = Navigator.of(context);  // 保存 Navigator 引用
    try {
      _showLoadingDialog();
      await _userProvider.updatePassword(result);
      navi.pop();  // 关闭 loading 对话框
      _showMessage('密码修改成功');
    } catch (e) {
      navi.pop();  // 关闭 loading 对话框
      _showMessage('密码修改失败：${e.toString()}', isError: true);
    }
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
    debugPrint('userinfo subscribe: ${_userProvider.userInfo?.subscribe}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
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
                  value: userProvider.userInfo?.subscribe == 1,
                  onChanged: (value) {
                    _handleNotificationToggle(value);
                  },
                ),
              ),
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: '修改密码',
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: _handlePasswordChange,
              ),
              _buildSettingItem(
                icon: _themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                title: '深色模式',
                trailing: Switch(
                  value: _themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    setState(() {
                      _themeProvider.setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
