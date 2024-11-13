import 'package:flutter/material.dart';
import 'package:lucky_community/model/classify.dart';
import 'package:lucky_community/page/community/article_list.dart';
import 'package:lucky_community/provider/community.dart';
import 'package:provider/provider.dart';

class SubCategoryTabView extends StatefulWidget {
  final int parentId;
  final Widget child;
  List<Classify> subCategories = [];
  SubCategoryTabView({super.key, required this.parentId, required this.child});
  @override
  State<SubCategoryTabView> createState() => _SubCategoryTabViewState();
}

class _SubCategoryTabViewState extends State<SubCategoryTabView>
    with TickerProviderStateMixin {
  late CommunityProvider provider;
  late TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.subCategories.length, vsync: this);
    _tabController?.addListener(_handleTabSelection);

    provider = Provider.of<CommunityProvider>(context, listen: false);
    provider.getArticlesClassifys(widget.parentId).then((value) {
      setState(() {
        widget.subCategories = value.map((e) => e).toList();
        _initializeTabController();
      });
    });
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  void _initializeTabController() {
    // 如果已有 TabController，先移除监听器并销毁它
   _tabController?.removeListener(_handleTabSelection); // 使用 ! 强制解包
    _tabController?.dispose();

    // 初始化新的 TabController
    _tabController = TabController(length: widget.subCategories.length, vsync: this);
    _tabController?.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      provider.setCurrentClassify(widget.subCategories[_tabController!.index].id);
      provider.getCurrentListDataByArticle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.subCategories.isEmpty? const SizedBox(): Column(
      children: [
        TabBar(
          controller: _tabController??TabController(length: widget.subCategories.length, vsync: this),
          isScrollable: true,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: widget.subCategories
              .map((subCategory) => Tab(text: subCategory.title))
              .toList(),
        ),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }
}
