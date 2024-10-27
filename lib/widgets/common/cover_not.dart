import 'package:flutter/material.dart';

class NoCoverWidget extends StatelessWidget {
  const NoCoverWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

              width: 100,
              height: 100,
      // 使用 BoxDecoration 来设置背景颜色和圆角
      decoration: BoxDecoration(
        color: Color(0xFFE2E8F0), // 设置半透明灰色背景
      ),
      // 使用 padding 来调整文本的显示位置
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const Text(
        '暂无封面',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey, // 设置文本颜色为白色
        ),
      ),
    );
  }
}
