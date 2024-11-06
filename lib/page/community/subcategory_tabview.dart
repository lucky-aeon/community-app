import 'package:flutter/material.dart';
import 'package:lucky_community/provider/community.dart';
import 'package:provider/provider.dart';

class SubCategoryTabView extends StatefulWidget {
  final int parentId;
  final Widget child;
  List<String> subCategories = [];
  SubCategoryTabView({super.key, required this.parentId, required this.child});
  @override
  State<SubCategoryTabView> createState() => _SubCategoryTabViewState();
}

class _SubCategoryTabViewState extends State<SubCategoryTabView> {
  late CommunityProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CommunityProvider>(context, listen: false);
    provider.getArticlesClassifys(widget.parentId).then((value) {
      setState(() {
        widget.subCategories = value.map((e)=> e.title).toList();
        debugPrint("subCategories: ${widget.subCategories}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.subCategories.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: widget.subCategories
                .map((subCategory) => Tab(text: subCategory))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: widget.subCategories.map((subCategory) {
                return Center(child: Text(subCategory));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
