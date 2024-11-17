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
          return Image.network(
                              ApiBase.getUrlByQueryToken(uri.toString()),
                              fit: BoxFit.cover,
                            );
        });
  }
}
