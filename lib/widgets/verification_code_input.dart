import 'package:flutter/material.dart';

class VerificationCodeInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const VerificationCodeInput({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VerificationCodeInputState createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  final int _codeLength = 5;
  List<String> _code = []; // 存储每个输入框的内容

  @override
  void initState() {
    super.initState();
    // 初始化 code 数组为空字符串，长度为 _codeLength
    _code = List.generate(_codeLength, (index) => '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 10), // label 和输入框之间的间距
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_codeLength, (index) {
            return Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                textAlign: TextAlign.center,
                maxLength: 1, // 每个输入框限制为一个字符
                decoration: InputDecoration(
                  filled: true, // 填充输入区域
                  fillColor: const Color.fromARGB(58, 179, 179, 179), // 灰色背景
                  counterText: '', // 隐藏计数器
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none, // 无边框
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _code[index] = value; // 更新对应位置的值
                    _updateController(); // 更新主 controller 的内容
                  });

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
        ),
      ],
    );
  }

  // 更新主控制器的值，将 _code 数组合并成字符串
  void _updateController() {
    widget.controller.text = _code.join();
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
  }
}
