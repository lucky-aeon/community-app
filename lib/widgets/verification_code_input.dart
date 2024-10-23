import 'package:flutter/material.dart';

class VerificationCodeInput extends StatefulWidget {
  final TextEditingController controller;

  const VerificationCodeInput({super.key, required this.controller});

  @override
  _VerificationCodeInputState createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  final FocusNode _focusNode = FocusNode();
  final int _codeLength = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_codeLength, (index) {
        return Container(
          width: 50,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            textAlign: TextAlign.center,
            maxLength: 1, // 每个输入框限制为一个字符
            decoration: InputDecoration(
              counterText: '', // 隐藏计数器
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            onChanged: (value) {
              // 更新主控制器的内容
              widget.controller.text = _getCurrentValue();
              widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));

              if (value.length == 1 && index < _codeLength - 1) {
                // 自动聚焦到下一个输入框
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                // 如果删除，聚焦到前一个输入框
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        );
      }),
    );
  }

  // 获取当前的验证码
  String _getCurrentValue() {
    return widget.controller.text;
  }
}