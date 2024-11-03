import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context)  {
    return DefaultTabController(
      length: 3, // 选项卡的数量
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.article), text: "文章(Article)"),
              Tab(icon: Icon(Icons.help), text: "问答(QA)"),
              Tab(icon: Icon(Icons.share), text: "话题(Topic)"),
            ],
          ),
          bottom: Tab(child: Divider(height: 1),),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("文章")),
            Center(child: Text("问答")),
            Center(child: Text("话题")),
          ],
        ),
      ),
    );
  }  
}