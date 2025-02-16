import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:lucky_community/provider/comment.dart';
import 'package:lucky_community/utils/date.dart';
import 'item.dart';
import 'package:lucky_community/utils/toast.dart';
import 'package:lucky_community/provider/user.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final lg = Logger('CommentsPage');
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final provider = context.read<CommentProvider>();
    final success = await provider.postComment(
      content: _commentController.text,
      parentId: provider.replyToComment?.id,
      rootId: provider.replyToComment?.id,
      toUserId: provider.replyToComment?.fromUserId,
      refreshChild: true,
    );

    if (success) {
      _commentController.clear();
      if (mounted) {
        Toast.show(context, '评论发布成功');
      }
    } else {
      if (mounted) {
        Toast.show(context, '评论发布失败', isError: true);
      }
    }
  }

  void _handleUserTap(int userId) {
    lg.info('Clicked user: $userId');
  }

  Widget _buildInputBar(CommentProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
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
                    color: Colors.grey[100],
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
                onPressed: _submitComment,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Consumer<CommentProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Consumer<CommentProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          '${provider.articleComments.length} 评论',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Comment List
              Expanded(
                child: Consumer<CommentProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading &&
                        provider.articleComments.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!provider.isLoading &&
                        provider.articleComments.isEmpty) {
                      return const Center(child: Text("暂无评论"));
                    }

                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: provider.articleComments.length,
                        itemBuilder: (context, index) {
                          final comment = provider.articleComments[index];
                          return CommentItem(
                            avatarUrl: (comment.fromUserAvatar ?? "").isNotEmpty
                                ? comment.fromUserAvatar!
                                : "",
                            username: comment.fromUserName,
                            commentText: comment.content,
                            timeAgo:
                                formatFileModificationDate(comment.createdAt!),
                            likeCount: 0,
                            isLiked: false,
                            userId: comment.fromUserId,
                            onUserTap: _handleUserTap,
                            comment: comment,
                            reply: comment.childComments?.isNotEmpty == true
                                ? Column(
                                    children:
                                        comment.childComments!.map((reply) {
                                      String replyText = reply.content;
                                      if (reply.toUserId != null &&
                                          reply.toUserId !=
                                              comment.fromUserId) {
                                        replyText =
                                            "@${reply.toUserName} $replyText";
                                      }

                                      return ReplyComment(
                                        username: reply.fromUserName,
                                        commentText: replyText,
                                        timeAgo: formatFileModificationDate(
                                            reply.createdAt!),
                                        userId: reply.fromUserId,
                                        replyToUserId: reply.toUserId,
                                        replyToUsername: reply.toUserName,
                                        onUserTap: _handleUserTap,
                                        comment: reply,
                                      );
                                    }).toList(),
                                  )
                                : null,
                            isOwner: comment.fromUserId ==
                                context.read<UserProvider>().currentUserId,
                            onDelete: () {
                              provider
                                  .deleteComment(comment.id)
                                  .then((success) {
                                if (success) {
                                  // ignore: use_build_context_synchronously
                                  Toast.show(context, '删除成功');
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Toast.show(context, '删除失败', isError: true);
                                }
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              // Input
              _buildInputBar(provider),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
