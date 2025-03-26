import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/course.dart';
import 'package:lucky_community/widgets/markdown/preview.dart';
import 'package:provider/provider.dart';
import 'package:lucky_community/widgets/comment/list.dart';
import 'package:lucky_community/provider/comment.dart';

class CourseDetailPage extends StatefulWidget {
  final Course courseDetail;

  const CourseDetailPage({super.key, required this.courseDetail});

  @override
  State<StatefulWidget> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool _showFab = true;
  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showFab) setState(() => _showFab = false);
    }
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showFab) setState(() => _showFab = true);
    }
  }

  void _showComments() {
    context.read<CommentProvider>().initArticleComments(
          widget.courseDetail.id,
          widget.courseDetail.userId,
        );

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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  widget.courseDetail.cover.isNotEmpty
                      ? Image.network(
                          width: double.infinity,
                          height: double.infinity,
                          ApiBase.getUrlNoRequest(widget.courseDetail.cover),
                          headers: {ApiBase.AuthorizationKey: ApiBase.token},
                          fit: BoxFit.cover,
                        )
                      : Container(
                          padding: const EdgeInsets.only(top: 35),
                          color: Colors.grey,
                          child: const Center(
                            child: Text('没有封面', style: TextStyle(fontSize: 30)),
                          ),
                        ),
                  Container(color: Colors.black.withOpacity(0.5)),
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 课程信息行
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 左侧信息
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 观看数
                                  Row(
                                    children: [
                                      const Icon(Icons.visibility,
                                          size: 16, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.courseDetail.views}观看',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // 评分
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          size: 16, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.courseDetail.score}分',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // 右侧价格
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '¥${widget.courseDetail.money}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            title: Text(
              widget.courseDetail.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 课程内容
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 技术标签
                  if (widget.courseDetail.technologys.isNotEmpty) ...[
                    const Text(
                      '课程技术栈',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.courseDetail.technologys
                          .map((tech) => Chip(
                                label: Text(tech),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // 课程描述
                  const Text(
                    '课程简介',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.courseDetail.desc,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 课程章节
                  if (widget.courseDetail.sections != null) ...[
                    const Text(
                      '课程章节',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (widget.courseDetail.sections as List).length,
                      itemBuilder: (context, index) {
                        final section = (widget.courseDetail.sections as List)[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.play_circle_outline),
                            title: Text(section['title'] ?? '未命名章节'),
                            subtitle: Text(section['desc'] ?? '暂无描述'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // TODO: 实现章节播放功能
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('播放功能开发中...')),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0, _showFab ? 0 : 100, 0),
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
                    heroTag: 'buy',
                    onPressed: _isExpanded ? () {
                      // TODO: 实现购买课程逻辑
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('购买功能开发中...')),
                      );
                    } : null,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                child: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
