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
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color.fromARGB(135, 158, 158, 158), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color.fromARGB(135, 158, 158, 158), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color.fromARGB(135, 33, 149, 243), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    );
  }
}
