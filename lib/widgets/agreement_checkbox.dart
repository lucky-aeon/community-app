import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart' show rootBundle;

class AgreementCheckbox extends StatefulWidget {
  @override
  _AgreementCheckboxState createState() => _AgreementCheckboxState();
}

class _AgreementCheckboxState extends State<AgreementCheckbox> {
  bool _isAgreed = false;
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
                setState(() {
                  _isAgreed = false; // 点击同意时勾选
                });
                Navigator.of(context).pop(); // 点击拒绝时关闭对话框
              },
            ),
            CupertinoDialogAction(
              child: const Text('同意'),
              onPressed: () {
                setState(() {
                  _isAgreed = true; // 点击同意时勾选
                });
                Navigator.of(context).pop(); // 关闭对话框
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
              value: _isAgreed,
              onChanged: (value) {
                if (value == false) {
                  setState(() {
                    _isAgreed = false; // 点击同意时勾选
                  });
                  return;
                }
                // 不直接修改复选框状态，防止未同意时也被选中
                if (value == true) {
                  _showAgreementDialog(); // 仅在选中时显示对话框
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
