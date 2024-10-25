import 'package:flutter/material.dart';
import 'package:lucky_community/widgets/article/list_item.dart';

class LatestPage extends StatelessWidget {
  const LatestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ListView(
        children: const [
          ArticleListItem(
            title: '抖音项目面试提问',
            abstract: '最近要面试了，主要学习了抖音项目，UP能不能总结一下面试官常问的问题？',
            likeCount: 5,
            commentCount: 2,
            coverImageUrl: 'https://oss.xhyovo.cn/14%2F1717610846157?Expires=1729839437&OSSAccessKeyId=LTAI5tHthVoXiFMEbmHpsW4w&Signature=R6j2o4rv6%2F6DKsavohnRbe16kLQ%3D', // 封面图片地址
          ),
          ArticleListItem(
            title: 'Flutter 项目优化',
            abstract: '如何优化你的 Flutter 项目性能，本文提供了一些实用的技巧。',
            likeCount: 12,
            commentCount: 5,
            coverImageUrl: 'https://oss.xhyovo.cn/14%2F1717610846157?Expires=1729839437&OSSAccessKeyId=LTAI5tHthVoXiFMEbmHpsW4w&Signature=R6j2o4rv6%2F6DKsavohnRbe16kLQ%3D',
          ),
          // 添加更多文章项...
        ],
      ),);
  }
}