
import 'package:flutter/material.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart' as article_model;
import 'package:lucky_community/provider/article.dart';
import 'package:lucky_community/utils/date.dart' as date_utils;
import 'package:lucky_community/widgets/markdown/preview.dart';
import 'package:provider/provider.dart';

class ArticleDetailPage extends StatefulWidget {
  final article_model.Article articleDetail;

  const ArticleDetailPage({super.key, required this.articleDetail});

  @override
  State<StatefulWidget> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late ArticleProvider articleProvider;

  @override
  void initState() {
    super.initState();
    articleProvider = Provider.of<ArticleProvider>(context, listen: false);
    getArticleDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            expandedHeight: 200, // 设置扩展的高度
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // 封面图
                  (widget.articleDetail.cover ?? "").isNotEmpty
                      ? Image.network(
                       width: double.infinity,
                       height: double.infinity,
                            headers: {"Authorization": ApiBase.token},
                              ApiBase.getUrl(widget.articleDetail.cover!),
                              fit: BoxFit.cover,
                            )
                      : Container(
                          padding: const EdgeInsets.only(top: 35),
                          color: Colors.grey, // 默认背景色
                          child: const Center(
                            child: Text('没有封面', style: TextStyle(fontSize: 30)),
                          ),
                        ),
                  // 黑色半透明遮罩
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  // 文章发布者、发布时间、点赞数
                  Positioned(
                    bottom: 20,
                    left: 16,
                    child: Row(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_box,
                                size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              widget.articleDetail.userName,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.timelapse,
                                size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              date_utils.formatFileModificationDate(
                                  widget.articleDetail.updatedAt),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.thumb_up,
                                size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              widget.articleDetail.like.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pinned: true, // 固定在顶部
            title: Text(
              widget.articleDetail.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 文章内容
          SliverToBoxAdapter(
            child: HighMarkdownPrevie(
              data: widget.articleDetail.content ?? "",
            ),
          ),
        ],
      ),
    );
  }

  void getArticleDetail() async {
    article_model.Article? detail =
        await articleProvider.getArticleDetail(widget.articleDetail.id);
    if (detail == null) {
      return;
    }
    setState(() {
      widget.articleDetail.content = detail.content ?? "";
    });
  }
}
