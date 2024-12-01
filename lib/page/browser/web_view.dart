import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lucky_community/api/base.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InAppBrowser extends StatefulWidget {
  final String url;
  final String title;

  const InAppBrowser({
    Key? key,
    required this.url,
    this.title = '',
  }) : super(key: key);

  @override
  State<InAppBrowser> createState() => _InAppBrowserState();
}

class _InAppBrowserState extends State<InAppBrowser> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _currentUrl = '';
  String _pageTitle = '';
  double _loadingProgress = 0.0;
  bool _showProgress = true;
  bool _showCopySuccess = false;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
    _pageTitle = widget.title;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _currentUrl = url;
              _loadingProgress = 0.0;
              _showProgress = true;
            });
          },
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100;
            });
          },
          onPageFinished: (String url) async {
            final title = await _controller.getTitle();
            setState(() {
              _isLoading = false;
              _loadingProgress = 1.0;
              if (title != null) {
                _pageTitle = title;
              }
            });
            _controller.runJavaScript(
              'localStorage.setItem("token", "${ApiBase.token}");'
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                setState(() {
                  _showProgress = false;
                });
              }
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _copyUrlToClipboard() {
    Clipboard.setData(ClipboardData(text: _currentUrl)).then((_) {
      setState(() {
        _showCopySuccess = true;
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _showCopySuccess = false;
          });
        }
      });
    });
  }

  String get _displayTitle {
    if (_showCopySuccess) {
      return '复制网址成功！';
    }
    return _isLoading ? _currentUrl : _pageTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _copyUrlToClipboard,
              child: Text(
                _displayTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: _showCopySuccess ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _showProgress ? 2 : 0,
              child: LinearProgressIndicator(
                value: _loadingProgress,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 2,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.reload(),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser, color: Colors.white),
            onPressed: () async {
              await launchUrlString(
                _currentUrl,
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
        ],
      ),
    );
  }
} 