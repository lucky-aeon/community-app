import 'package:flutter/material.dart';
import 'package:lucky_community/widgets/agreement_checkbox.dart';
import 'package:lucky_community/widgets/rounded_text_field.dart';
import 'package:lottie/lottie.dart';
import 'package:lucky_community/widgets/verification_code_input.dart';


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
  bool _agreeToTerms = false;  // 协议同意状态

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lucky Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child:    Lottie.asset("assets/lottie/hello.json", height: 250),
            ),
            RoundedTextField(label: 'Username', controller: _usernameController),
            const SizedBox(height: 16),
            // 密码输入框
            RoundedTextField(
              label: 'Password', 
              controller: _passwordController, 
              obscureText: true),
            const SizedBox(height: 16),
            // 验证码输入框
            VerificationCodeInput(controller: _captchaController),
            const SizedBox(height: 16),
            // 协议同意复选框
            AgreementCheckbox(),
            const SizedBox(height: 16),
            // 登录按钮
            ElevatedButton(
              onPressed: _agreeToTerms ? _login : null, // 仅在同意协议时允许登录
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String captcha = _captchaController.text;

    // 这里可以添加你的登录逻辑，比如请求服务器
    print('Username: $username, Password: $password, Captcha: $captcha');
  }
}
