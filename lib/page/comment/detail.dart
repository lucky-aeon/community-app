import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/comment.dart';
import 'package:lucky_community/provider/comment.dart';
import 'package:lucky_community/utils/date.dart';
import 'package:lucky_community/widgets/comment/item.dart';
import 'package:lucky_community/widgets/markdown/preview.dart';
import 'package:provider/provider.dart';

class CommentDetailPage extends StatefulWidget {
  final Comment comment;

  const CommentDetailPage({
    super.key,
    required this.comment,
  });

  @override
  State<CommentDetailPage> createState() => _CommentDetailPageState();
}

class _CommentDetailPageState extends State<CommentDetailPage> {
  final lg = Logger('CommentDetailPage');
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final provider = context.read<CommentProvider>();
      provider.initCommentDetail(widget.comment);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleReply(BuildContext context, Comment replyToComment) {
    context.read<CommentProvider>().setReplyTo(replyToComment);
  }

  Future<void> _submitComment(CommentProvider provider) async {
    if (_commentController.text.trim().isEmpty) return;

    final success = await provider.postComment(
      content: _commentController.text,
      parentId: widget.comment.id,
      rootId: widget.comment.id,
      toUserId:
          provider.replyToComment?.fromUserId ?? widget.comment.fromUserId,
      refreshChild: false,
    );

    if (success) {
      _commentController.clear();
    }
  }

  Widget _buildAvatar(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        child: const Icon(
          Icons.person,
          size: 24,
          color: Colors.grey,
        ),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      child: ClipOval(
        child: Image.network(
          ApiBase.getUrlByQueryToken(avatarUrl),
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 24,
              color: Colors.grey,
            );
          },
        ),
      ),
    );
  }

  void _handleUserTap(BuildContext context, int userId) {
    // 处理用户点击事件
    lg.info('Clicked user: $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('评论详情'),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // 返回前刷新文章评论列表
            context.read<CommentProvider>().getArticleComments();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<CommentProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 主评论
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 评论者信息
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAvatar(widget.comment.fromUserAvatar),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => _handleUserTap(
                                      context, widget.comment.fromUserId),
                                  child: Text(
                                    widget.comment.fromUserName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatFileModificationDate(
                                      widget.comment.createdAt!),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // 评论内容
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: HighMarkdownPrevie(
                          data: widget.comment.content,
                        ),
                      ),
                    ],
                  ),
                ),
                // 分割线
                const Divider(height: 1),
                // 回复列表
                if (provider.replyComments.isNotEmpty)
                  Container(
                    color: Theme.of(context).colorScheme.background,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '回复 (${provider.replyComments.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...provider.replyComments.map((reply) => ReplyComment(
                              comment: reply,
                              username: reply.fromUserName,
                              commentText: reply.content,
                              timeAgo:
                                  formatFileModificationDate(reply.createdAt!),
                              userId: reply.fromUserId,
                              replyToUserId: reply.toUserId,
                              replyToUsername: reply.toUserName,
                              onUserTap: (userId) =>
                                  _handleUserTap(context, userId),
                              onReply: (replyComment) =>
                                  _handleReply(context, replyComment),
                            )),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<CommentProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _buildInputBar(provider),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(CommentProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.surface)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (provider.replyToComment != null)
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    provider.replyHint ?? '',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    onPressed: () => provider.clearReplyTo(),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    // color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _commentController,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: provider.replyHint ?? '说点什么吧...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _submitComment(provider),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                iconSize: 24,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
