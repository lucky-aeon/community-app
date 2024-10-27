import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    providerHome = Provider.of<HomeProvider>(context);
    providerHome.getLatestArticles();
    return Column(
      children: buildItems(),
    );
  }

  List<Widget> buildItems() {
    return providerHome.articles.map((article) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: ArticleListItem(
          article: article
        ),
      );
    }).toList();
  }
}
