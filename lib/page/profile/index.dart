import 'package:flutter/material.dart';
import 'package:lucky_community/page/auth/login.dart';
import 'package:lucky_community/page/profile/setting.dart';
import 'package:lucky_community/provider/auth.dart';
import 'package:lucky_community/provider/user.dart';
import 'package:provider/provider.dart';
import 'package:lucky_community/api/base.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // 个人信息部分
                  Consumer<UserProvider>(
                    builder: (context, provider, child) {
                      final userInfo = provider.userInfo;
                      if (userInfo == null) return const SizedBox();

                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // 顶部标题栏
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'hi, ${userInfo.name}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  icon:
                                      const Icon(Icons.notifications_outlined),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            // 头像和认证标记
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: userInfo.avatar.isNotEmpty
                                      ? NetworkImage(
                                          ApiBase.getUrlNoRequest(
                                              userInfo.avatar),
                                          headers: {
                                              ApiBase.AuthorizationKey:
                                                  ApiBase.token,
                                            })
                                      : null,
                                  child: userInfo.avatar.isEmpty
                                      ? const Icon(Icons.person,
                                          size: 60, color: Colors.grey)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              userInfo.desc,
                              style: const TextStyle(color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // 操作按钮
                            _builderMidButtons(true),
                          ],
                        ),
                      );
                    },
                  ),
                  // 统计数据
                  _builderStatistics(false),
                  // 菜单列表
                  // _MenuItem(icon: Icons.edit, title: 'Edit Profile', onTap: () {}),
                  _MenuItem(
                      icon: Icons.settings, title: 'Settings', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AppSettingPage()));
                      }),
                  // _MenuItem(icon: Icons.tune, title: 'Preferences', onTap: () {}),
                  // _MenuItem(icon: Icons.help_outline, title: 'Help and Support', onTap: () {}),
                  _MenuItem(icon: Icons.logout, title: 'Logout', onTap: () async {
                    await _authProvider.logout();
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  }),
                  // 底部留白，为底部导航栏腾出空间
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _builderStatistics(bool noHide) {
    if (noHide != true) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '492', label: 'Upcoming'),
          _StatItem(value: '329', label: 'Past'),
          _StatItem(value: '1124', label: 'Rating'),
        ],
      ),
    );
  }

  // 关注按钮，游客显示关注按钮，已登录显示关注按钮和取消关注按钮
  Widget _builderMidButtons(bool hide) {
    if (hide == true) return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('关 注'),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey[200],
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      ],
    );
  }
}
