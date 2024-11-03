import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:video_player/video_player.dart';

class VideoElementBuilder extends MarkdownElementBuilder {
  VideoElementBuilder();

  @override
  bool isBlockElement() {
    return true;
  }

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    return null;
  }

  @override
  Widget visitElementAfterWithContext(BuildContext context, md.Element element,
      TextStyle? preferredStyle, TextStyle? parentStyle) {
    return VideoPlayerWidget(url: element.attributes['url']!, title: element.attributes['title']!);
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final String title;

  VideoPlayerWidget({required this.url, this.title = '无标题'});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _onTap() {
    if (_isPlaying) {
      _togglePlayPause(); // 点击时暂停
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: _onTap, // 点击视频区域进行播放/暂停
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              // 根据播放状态显示或隐藏按钮
              if (_controller.value.isInitialized && !_isPlaying)
                IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    size: 64,
                    color: const Color.fromARGB(255, 13, 222, 135),
                  ),
                  onPressed: _togglePlayPause,
                ),
              // 显示加载指示器
              if (!_controller.value.isInitialized)
                Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );
  }
}


class CustomTagBlockSyntax extends md.BlockSyntax {
  @override
  bool canParse(md.BlockParser parser) {
    return parser.current.content.startsWith('!video');
  }

  @override
  RegExp get pattern => RegExp(r'!video\[(.*?)\]\((.*?)\)');

  @override
  md.Node parse(md.BlockParser parser) {
    final match = pattern.firstMatch(parser.current.content);
    if (match != null) {
      final String title = match.group(1) ?? '';
      final String url = match.group(2) ?? '';

      final md.Element element = md.Element.empty('video');
      element.attributes['title'] = title;
      element.attributes['url'] = url;

      return element;
    }

    // 如果没有匹配，返回一个空的 Element
    return md.Element.empty('text');
  }
}
