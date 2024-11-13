import 'package:flutter/material.dart';
import 'package:lucky_community/page/community/article_list.dart';
import 'package:lucky_community/page/community/subcategory_tabview.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 上层 Tab 数量
      child: Scaffold(
     
        body: Column(
          children: [
            SafeArea(
              child: const TabBar(
                tabs: [
                  Tab(text: "文章"),
                  Tab(text: "问答"),
                  Tab(text: "帮助"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SubCategoryTabView(
                      parentId: 2, child: const CommunityArticleList()), // 文章
                  SubCategoryTabView(
                      parentId: 1, child: const CommunityArticleList()), // 问答
                  SubCategoryTabView(
                      parentId: 3, child: const CommunityArticleList()), // 帮助
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

