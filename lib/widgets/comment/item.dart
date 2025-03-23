// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/comment.dart';
import 'package:lucky_community/page/comment/detail.dart';
import 'package:lucky_community/provider/comment.dart';
import 'package:lucky_community/provider/user.dart';
import 'package:lucky_community/utils/toast.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String commentText;
  final String timeAgo;
  final int likeCount;
  final bool isLiked;
  final Widget? reply;
  final int? userId;
  final Function(int)? onUserTap;
  final Comment comment;
  final bool isOwner;
  final Function()? onDelete;

  const CommentItem({
    super.key,
    required this.avatarUrl,
    required this.username,
    required this.commentText,
    required this.timeAgo,
    required this.likeCount,
    required this.isLiked,
    this.reply,
    this.userId,
    this.onUserTap,
    required this.comment,
    required this.isOwner,
    this.onDelete,
  });

  void _handleReply(BuildContext context) {
    context.read<CommentProvider>().setReplyTo(comment);
  }

  Widget _buildAvatar(BuildContext context) {
    if (avatarUrl.isEmpty) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CommentDetailPage(
              comment: comment,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(context),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: userId != null
                            ? () => onUserTap?.call(userId!)
                            : null,
                        child: Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: userId != null ? Colors.blue : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        commentText,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            timeAgo,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 16),
                          InkWell(
                            onTap: () => _handleReply(context),
                            child: Text(
                              '${comment.childCommentNumber > 0 ? '(${comment.childCommentNumber}) ' : ''}回复',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (reply != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: reply!,
                        ),
                    ],
                  ),
                ),
                Consumer<UserProvider>(
                  builder: (context, provider, child) {
                    if (provider.userInfo?.id == comment.fromUserId) {
                      return IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const SizedBox()),
                          )
                              .then((_) {
                            context
                                .read<CommentProvider>()
                                .deleteComment(
                                  comment.id,
                                  isChild: false,
                                )
                                .then((success) {
                              if (success) {
                                Toast.show(context, '删除成功');
                              } else {
                                Toast.show(context, '删除失败', isError: true);
                              }
                            });
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        iconSize: 20,
                        color: Colors.grey[400],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ],
      ),
    );
  }
}

class ReplyComment extends StatelessWidget {
  final String username;
  final String commentText;
  final String timeAgo;
  final int? userId;
  final int? replyToUserId;
  final String? replyToUsername;
  final Function(int)? onUserTap;
  final Comment comment;
  final Function(Comment)? onReply;

  const ReplyComment({
    super.key,
    required this.username,
    required this.commentText,
    required this.timeAgo,
    this.userId,
    this.replyToUserId,
    this.replyToUsername,
    this.onUserTap,
    required this.comment,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: userId != null ? () => onUserTap?.call(userId!) : null,
                child: Text(
                  username,
                  style: TextStyle(
                    color: userId != null ? Colors.blue : Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (replyToUsername != null) ...[
                Text(' 回复 ',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                GestureDetector(
                  onTap: replyToUserId != null
                      ? () => onUserTap?.call(replyToUserId!)
                      : null,
                  child: Text(
                    replyToUsername!,
                    style: TextStyle(
                      color: replyToUserId != null
                          ? Colors.blue
                          : Colors.grey[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            commentText,
            style: const TextStyle(fontSize: 14, height: 1.3),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                timeAgo,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 16),
              if (onReply != null)
                GestureDetector(
                  onTap: () => onReply?.call(comment),
                  child: Text(
                    '${comment.childCommentNumber > 0 ? '(${comment.childCommentNumber}) ' : ''}回复',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              const SizedBox(width: 16),
              Consumer<UserProvider>(
                builder: (context, provider, child) {
                  if (provider.userInfo?.id == comment.fromUserId) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const SizedBox()),
                        )
                            .then((_) {
                          context
                              .read<CommentProvider>()
                              .deleteComment(
                                comment.id,
                                isChild: true,
                              )
                              .then((success) {
                            if (success) {
                              Toast.show(context, '删除成功');
                            } else {
                              Toast.show(context, '删除失败', isError: true);
                            }
                          });
                        });
                      },
                      child: Text(
                        '删除',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
