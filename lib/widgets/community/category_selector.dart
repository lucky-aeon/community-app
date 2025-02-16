import 'package:flutter/material.dart';
import 'package:lucky_community/model/classify.dart';
import 'package:lucky_community/provider/community.dart';
import 'package:provider/provider.dart';

class CategorySelector extends StatelessWidget {
  final List<Classify> parentCategories = [
    Classify(id: 2, title: '文章'),
    Classify(id: 1, title: '问答'),
    Classify(id: 3, title: '帮助'),
  ];

  CategorySelector({super.key});

  String _getCurrentCategoryTitle(int currentId) {
    return parentCategories
        .firstWhere((category) => category.id == currentId,
            orElse: () => Classify(id: 2, title: '文章'))
        .title;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        final currentTitle = _getCurrentCategoryTitle(provider.currentParentId);
        return TextButton.icon(
          icon: const Icon(Icons.filter_list),
          label: Text(currentTitle),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '选择分类',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Divider(),
                      ...parentCategories.map((category) {
                        final isSelected =
                            provider.currentParentId == category.id;
                        return ListTile(
                          title: Text(
                            category.title,
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : null,
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: Theme.of(context).primaryColor,
                                )
                              : null,
                          onTap: () {
                            provider.setCurrentParentId(category.id);
                            Navigator.pop(context);
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
