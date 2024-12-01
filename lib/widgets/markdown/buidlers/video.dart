import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lucky_community/api/base.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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
    if (element.tag == 'video') {
      return VideoPlayerWidget(
        url: ApiBase.getUrlNoRequest(element.attributes['url']!),
        title: element.attributes['title']!,
      );
    }
    return const SizedBox.shrink();
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final String title;

  const VideoPlayerWidget({
    Key? key,
    required this.url,
    this.title = '无标题',
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        httpHeaders: {
          ApiBase.AuthorizationKey: ApiBase.token,
        },
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        placeholder: Center(
          child: CircularProgressIndicator(),
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white,
        ),
        showOptions: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.white, size: 42),
                SizedBox(height: 16),
                Text(
                  '视频加载失败',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
        ],
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (error) {
      print('Error initializing video player: $error');
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        AspectRatio(
          aspectRatio: _isInitialized
              ? _videoPlayerController.value.aspectRatio
              : 16 / 9,
          child: _isInitialized && _chewieController != null
              ? Chewie(controller: _chewieController!)
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
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

      parser.advance();

      return element;
    }

    parser.advance();
    return md.Element.empty('empty');
  }
}
