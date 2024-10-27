import 'package:flutter/material.dart';
import 'package:lucky_community/layout/mobile.dart';
import 'package:lucky_community/provider/user.dart';
import 'package:lucky_community/widgets/agreement_checkbox.dart';
import 'package:lucky_community/widgets/rounded_text_field.dart';
import 'package:lottie/lottie.dart';
import 'package:lucky_community/widgets/verification_code_input.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  late AuthProvider _authProvider;

  bool _agreeToTerms = true; // 协议同意状态
  bool _loading = false; // 加载状态

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 从 Provider 中获取 AuthProvider 的实例
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 255),
      appBar: AppBar(
        title: const Text('Lucky Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Lottie.asset("assets/lottie/hello.json", height: 250),
            ),
            RoundedTextField(
                label: 'Username', controller: _usernameController),
            const SizedBox(height: 16),
            // 密码输入框
            RoundedTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: true),
            const SizedBox(height: 16),
            // 验证码输入框
            VerificationCodeInput(
                label: "Captcha", controller: _captchaController),
            const SizedBox(height: 16),
            // 协议同意复选框
            AgreementCheckbox(
                isAgreed: _agreeToTerms,
                onAgreementChanged: (value) => {
                      setState(() {
                        _agreeToTerms = value;
                      })
                    }),
            const SizedBox(height: 16),
            // 登录按钮
            ElevatedButton(
              onPressed:
                  _agreeToTerms && !_loading ? _login : null, // 仅在同意协议时允许登录
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _loading = true;
    });
    String username = _usernameController.text;
    String password = _passwordController.text;
    // String captcha = _captchaController.text;
    await _authProvider.login(username, password);
    setState(() {
      _loading = false;
    });
    if (!mounted) return;

    if (_authProvider.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MobileLayout()),
        // MaterialPageRoute(builder: (context) => const LoginPage())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authProvider.errorMessage ?? '登录失败')),
      );
    }
  }
}
