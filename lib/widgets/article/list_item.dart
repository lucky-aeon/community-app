import 'package:flutter/material.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/page/article/detail.dart';
import 'package:lucky_community/widgets/common/cover_not.dart';

class ArticleListItem extends StatelessWidget {
  final Article article;

  const ArticleListItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => {
              // 点击事件
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailPage(
                      articleDetail: article, // 打开新页面
                    ),
                  ))
            },
        child: Container(
          // 设置背景色
          decoration: const BoxDecoration(
            color: Colors.white, // 白色背景
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0), // 每个列表项的间距
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
                        article.title,
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
                        article.abstract ?? '无摘要',
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
                          const Icon(Icons.thumb_up_outlined, size: 16),
                          const SizedBox(width: 4),
                          Text((article.like ?? 0).toString(),
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 16), // 图标和文字之间的间距
                          const Icon(Icons.comment_outlined, size: 16),
                          const SizedBox(width: 4),
                          Text((article.comments ?? 0).toString(),
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
                // 右侧封面图片
                const SizedBox(width: 10), // 左右两部分之间的间距
                // 封面图
                ClipRRect(
                    borderRadius: BorderRadius.circular(6.0), // 封面图圆角
                    child: SizedBox(
                      width: 125,
                      child: (article.cover ?? "").isEmpty
                          ? const NoCoverWidget()
                          : Image.network(
                            headers: {"Authorization": ApiBase.token},
                              ApiBase.baseUrl+article.cover!,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    )),
              ],
            ),
          ),
        ));
  }
}
