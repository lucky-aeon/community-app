import 'package:flutter/material.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/provider/community.dart';
import 'package:lucky_community/widgets/article/list_item.dart';
import 'package:provider/provider.dart';

class CommunityArticleList extends StatefulWidget {
  const CommunityArticleList({super.key});

  @override
  State<CommunityArticleList> createState() => _CommunityArticleListState();

}

class _CommunityArticleListState extends State<CommunityArticleList> {
  late CommunityProvider _communityProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        _communityProvider = Provider.of(context, listen: true);

    return SingleChildScrollView(child: Column(children: buildItems()),);
  }

  List<Widget> buildItems() {
    return _communityProvider.currentClassifyArticles.map((article) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: ArticleListItem(article: article),
      );
    }).toList();
  }
}

