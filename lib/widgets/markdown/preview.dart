import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/widgets/markdown/buidlers/video.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:lucky_community/page/browser/web_view.dart';

class HighMarkdownPrevie extends StatelessWidget {
  final String data;
  static final _buildersMap = <String, MarkdownElementBuilder>{
    'video': VideoElementBuilder(),
  };

  const HighMarkdownPrevie({
    super.key,
    required this.data,
  });

  void _showImageDialog(BuildContext context, String imageUrl) {
    bool isLandscape = false;

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (isLandscape) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl,
                    headers:
                        Map.from({ApiBase.AuthorizationKey: ApiBase.token}),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 40,
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      if (isLandscape) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    icon: Icon(
                      isLandscape
                          ? Icons.screen_lock_portrait
                          : Icons.screen_lock_landscape,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        isLandscape = !isLandscape;
                        if (isLandscape) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ]);
                        } else {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                          ]);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      builders: _buildersMap,
      shrinkWrap: true,
      blockSyntaxes: <md.BlockSyntax>[CustomTagBlockSyntax()],
      onTapLink: (text, href, title) {
        if (href != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InAppBrowser(
                url: href,
                title: title.isEmpty ? text : title,
              ),
            ),
          );
        }
      },
      imageBuilder: (uri, title, alt) {
        final imageUrl = ApiBase.getUrlNoRequest(uri.toString());
        return GestureDetector(
          onTap: () => _showImageDialog(context, imageUrl),
          child: Hero(
            tag: imageUrl,
            child: Image.network(
              imageUrl,
              headers: Map.from({ApiBase.AuthorizationKey: ApiBase.token}),
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
