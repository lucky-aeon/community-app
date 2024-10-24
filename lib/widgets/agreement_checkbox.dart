import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart' show rootBundle;

class AgreementCheckbox extends StatefulWidget {
  final bool isAgreed; // 从父组件接收的状态
  final Function(bool) onAgreementChanged; // 状态变化的回调函数

  const AgreementCheckbox({
    super.key,
    required this.isAgreed,
    required this.onAgreementChanged,
  });

  @override
  _AgreementCheckboxState createState() => _AgreementCheckboxState();
}

class _AgreementCheckboxState extends State<AgreementCheckbox> {
  String htmlContent = '';

  @override
  void initState() {
    super.initState();
    _loadHtmlContent();
  }

  Future<void> _loadHtmlContent() async {
    try {
      final html =
          await rootBundle.loadString('assets/data/community_user_xy.html');
      setState(() {
        htmlContent = html; // 更新状态
      });
    } catch (error) {
      print('Error loading HTML: $error');
    }
  }

  void _showAgreementDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('社区用户协议'),
          content: SizedBox(
            width: 500, // 固定宽度
            height: 300,
            child: SingleChildScrollView(
              child: Html(
                data: htmlContent,
                style: {
                  "body": Style(),
                },
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('拒绝'),
              onPressed: () {
                widget.onAgreementChanged(false); // 拒绝时通知父组件取消勾选
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('同意'),
              onPressed: () {
                widget.onAgreementChanged(true); // 同意时通知父组件勾选
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Checkbox(
              value: widget.isAgreed,
              onChanged: (value) {
                if (value == false) {
                  widget.onAgreementChanged(false); // 通知父组件取消勾选
                  return;
                }
                if (value == true) {
                  _showAgreementDialog(); // 显示对话框
                }
              },
            ),
            GestureDetector(
              onTap: () {
                _showAgreementDialog(); // 点击文本时显示对话框
              },
              child: const Text(
                '阅读并同意用户协议 《社区用户协议》',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
