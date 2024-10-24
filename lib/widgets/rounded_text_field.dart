import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  const RoundedTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false, // 默认不是密码框
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label, // 默认放在内部的label
        filled: true, // 填充输入区域
        fillColor: const Color.fromARGB(58, 179, 179, 179), // 灰色背景
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none, // 无边框
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none, // 无边框
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none, // 无边框
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        floatingLabelBehavior: FloatingLabelBehavior.auto, // 自动浮动
      ),
    );
  }
}
