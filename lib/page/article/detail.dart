import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart' as article_model;
import 'package:lucky_community/provider/article.dart';
import 'package:lucky_community/utils/date.dart' as date_utils;
import 'package:lucky_community/widgets/markdown/preview.dart';
import 'package:provider/provider.dart';
import 'package:lucky_community/widgets/comment/list.dart';  // 导入评论列表组件
import 'package:lucky_community/provider/comment.dart';

class ArticleDetailPage extends StatefulWidget {
  final article_model.Article articleDetail;

  const ArticleDetailPage({super.key, required this.articleDetail});

  @override
  State<StatefulWidget> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late ArticleProvider articleProvider;
  bool _showFab = true;  // 控制FAB的显示/隐藏
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    articleProvider = Provider.of<ArticleProvider>(context, listen: false);
    getArticleDetail();
    
    // 添加滚动监听
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // 滚动监听处理
  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showFab) {
        setState(() => _showFab = false);
      }
    }
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showFab) {
        setState(() => _showFab = true);
      }
    }
  }

  // 显示评论列表
  void _showComments() {
    // 先初始化评论数据
    context.read<CommentProvider>().initArticleComments(
      widget.articleDetail.id,
      widget.articleDetail.user?.id ?? 0,
    );

    // 然后显示评论列表
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const CommentsPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,  // 添加滚动控制器
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
                              ApiBase.getUrlByQueryToken(widget.articleDetail.cover!),
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: HighMarkdownPrevie(
                data: widget.articleDetail.content ?? "",
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: Duration(milliseconds: 300),
        offset: _showFab ? Offset.zero : Offset(0, 2),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton(
            onPressed: _showComments,
            child: Badge(
              label: Text(widget.articleDetail.comments?.toString() ?? '0'),  // 这里可以显示评论数量
              child: Icon(Icons.comment),
            ),
          ),
        ),
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
