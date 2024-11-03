import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/widgets/markdown/buidlers/video.dart';
import 'package:markdown/markdown.dart' as md;

class HighMarkdownPrevie extends StatelessWidget {
  final String data;
  static final _buidersMap = <String, MarkdownElementBuilder>{
    'video': VideoElementBuilder()
  };

  const HighMarkdownPrevie({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Markdown(
        data: data,
        builders: _buidersMap,
        shrinkWrap: true,
        blockSyntaxes: <md.BlockSyntax>[CustomTagBlockSyntax()],
        imageBuilder: (uri, title, alt) {
          return FutureBuilder<http.Response>(
            future: ApiBase.getNoJson(uri.toString()), // 异步获取图片 URL
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // 加载指示器
              } else if (snapshot.hasError) {
                return const Icon(Icons.error); // 错误提示
              } else {
                // 获取到图片数据后显示
                return Image.memory(snapshot.data!.bodyBytes); // 使用内存中的图片数据
              }
            },
          );
        });
  }
}
