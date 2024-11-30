import 'package:flutter/material.dart';
import 'package:lucky_community/provider/community.dart';
import 'package:lucky_community/widgets/article/list_item.dart';
import 'package:provider/provider.dart';

class CommunityArticleList extends StatefulWidget {
  const CommunityArticleList({super.key});

  @override
  State<CommunityArticleList> createState() => _CommunityArticleListState();
}

class _CommunityArticleListState extends State<CommunityArticleList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CommunityProvider>().getCurrentListDataByArticle(loadMore: true);
    }
  }

  Future<void> _onRefresh() async {
    await context.read<CommunityProvider>().getCurrentListDataByArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.currentClassifyArticles.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!provider.isLoading && provider.currentClassifyArticles.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text("暂无数据")),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: provider.currentClassifyArticles.length + 1,
          itemBuilder: (context, index) {
            if (index == provider.currentClassifyArticles.length) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: provider.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : provider.hasMore
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 15,
                                height: 2,
                                margin: const EdgeInsets.only(right: 10),
                                color: Colors.grey[300],
                              ),
                              Text(
                                '上拉加载更多',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                width: 15,
                                height: 2,
                                margin: const EdgeInsets.only(left: 10),
                                color: Colors.grey[300],
                              ),
                            ],
                          )
                        : Text(
                            '没有更多数据了',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 0.5),
              child: ArticleListItem(
                article: provider.currentClassifyArticles[index],
              ),
            );
          },
        );
      },
    );
  }
}
