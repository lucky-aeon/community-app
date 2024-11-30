import 'package:flutter/material.dart';
import 'package:lucky_community/layout/mobile.dart';
import 'package:lucky_community/page/auth/login.dart';


class HelloPage extends StatefulWidget {
  const HelloPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  @override
  void initState() {
    super.initState();

    // 在页面加载后 1 秒执行跳转
    Future.delayed(const Duration(seconds: 1), () {
      // 使用 Navigator.pushReplacement 跳转到 MobileLayout 页面
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (context) => const MobileLayout()),
        MaterialPageRoute(builder: (context) => const LoginPage())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '欢迎来到 Xhy OvO 社区 🍺',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}