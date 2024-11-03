import 'package:flutter/material.dart';
import 'package:lucky_community/model/article.dart';
import 'package:lucky_community/provider/home.dart';
import 'package:lucky_community/widgets/article/list_item.dart';
import 'package:provider/provider.dart';

class LatestPage extends StatefulWidget {
  const LatestPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _LatestPageState();
  }
}

class _LatestPageState extends State<LatestPage> {
  late HomeProvider providerHome;
  List<Article> latests = [];

  @override
  void initState() {
    super.initState();
    providerHome = Provider.of<HomeProvider>(context, listen: false);
    syncLatestList();
  }

  syncLatestList() async {
    await providerHome.getLatestArticles();
    if (providerHome.articles.isNotEmpty) {
      setState(() {
        latests = providerHome.articles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buildItems(),
    );
  }

  List<Widget> buildItems() {
    return latests.map((article) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: ArticleListItem(article: article),
      );
    }).toList();
  }
}
