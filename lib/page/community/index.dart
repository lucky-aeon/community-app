import 'package:flutter/material.dart';
import 'package:lucky_community/page/community/article_list.dart';
import 'package:lucky_community/provider/community.dart';
import 'package:lucky_community/widgets/community/category_selector.dart';
import 'package:lucky_community/widgets/community/sort_selector.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CommunityProvider>().init();
    });
  }

  Widget _buildHeader() {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              ...provider.parentCategories.map((category) {
                final isSelected = provider.currentParentId == category.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () => provider.setCurrentParentId(category.id),
                    child: Column(
                      children: [
                        Text(
                          category.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.blue[700] : Colors.grey[700],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 20,
                            height: 2,
                            color: Colors.blue[700],
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: '搜索',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          SortSelector(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 32,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 4),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: provider.subCategories.length,
            itemBuilder: (context, index) {
              final subCategory = provider.subCategories[index];
              final isSelected = provider.currentClassifyId == subCategory.id;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () {
                    provider.setCurrentClassify(subCategory.id);
                    provider.getCurrentListDataByArticle();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[700] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      subCategory.title,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[800],
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            toolbarHeight: 0,
            expandedHeight: 160,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    _buildSearchBar(),
                    _buildCategoryTabs(),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: CommunityArticleList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
