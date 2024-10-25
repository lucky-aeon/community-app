import 'package:flutter/material.dart';

class ArticleListItem extends StatelessWidget {
  final String title;
  final String abstract;
  final int likeCount;
  final int commentCount;
  final String coverImageUrl;

  const ArticleListItem({
    super.key,
    required this.title,
    required this.abstract,
    required this.likeCount,
    required this.commentCount,
    required this.coverImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // 每个列表项的间距
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧部分
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 文章标题
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8), // 间距
                // 文章摘要
                Text(
                  abstract,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8), // 间距
                // 点赞和评论数 (使用 Chip)
                Row(
                  children: [
                    Chip(
                      avatar: const Icon(Icons.thumb_up, size: 16),
                      label: Text(likeCount.toString()),
                      backgroundColor: Colors.blue.shade50,
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      avatar: const Icon(Icons.comment, size: 16),
                      label: Text(commentCount.toString()),
                      backgroundColor: Colors.green.shade50,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 右侧封面图片
          const SizedBox(width: 10), // 左右两部分之间的间距
          // 封面图
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // 封面图圆角
            child: Image.network(
              coverImageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

