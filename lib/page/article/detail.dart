import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/article.dart' as article_model;
import 'package:lucky_community/provider/article.dart';
import 'package:lucky_community/utils/date.dart' as date_utils;
import 'package:lucky_community/widgets/markdown/preview.dart';
import 'package:provider/provider.dart';
import 'package:lucky_community/widgets/comment/list.dart'; // 导入评论列表组件
import 'package:lucky_community/provider/comment.dart';

class ArticleDetailPage extends StatefulWidget {
  final article_model.Article articleDetail;

  const ArticleDetailPage({super.key, required this.articleDetail});

  @override
  State<StatefulWidget> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late ArticleProvider articleProvider;
  bool _showFab = true; // 控制FAB的显示/隐藏
  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = false;

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
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showFab) {
        setState(() => _showFab = false);
      }
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
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
    return GestureDetector(
      onTap: () {
        if (_isExpanded) {
          setState(() {
            _isExpanded = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          controller: _scrollController, // 添加滚动控制器
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor,
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
                            ApiBase.getUrlNoRequest(
                                widget.articleDetail.cover!),
                            headers: Map.from(
                                {ApiBase.AuthorizationKey: ApiBase.token}),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            padding: const EdgeInsets.only(top: 35),
                            color: Colors.grey, // 默认背景色
                            child: const Center(
                              child:
                                  Text('没有封面', style: TextStyle(fontSize: 30)),
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
        floatingActionButton: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(
              0,
              _showFab ? 0 : 100, // 隐藏时向下移动100像素
              0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _showFab ? 1 : 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _isExpanded ? 56.0 : 0.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isExpanded ? 1.0 : 0.0,
                    child: FloatingActionButton(
                      heroTag: 'like',
                      onPressed: _isExpanded
                          ? () async {
                              final success = await articleProvider
                                  .toggleLike(widget.articleDetail.id);
                              if (success) {
                                setState(() {
                                  widget.articleDetail.like =
                                      (widget.articleDetail.like ?? 0) + 1;
                                });
                              }
                            }
                          : null,
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: _isExpanded ? 16 : 0),
                FloatingActionButton(
                  onPressed: () {
                    if (_isExpanded) {
                      _showComments();
                    }
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: const CircleBorder(),
                  child: Badge(
                    backgroundColor: Colors.red,
                    label: Text(
                      widget.articleDetail.comments?.toString() ?? '0',
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: const Icon(Icons.comment, color: Colors.white),
                  ),
                ),
              ],
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
