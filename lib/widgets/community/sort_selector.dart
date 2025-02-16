import 'package:flutter/material.dart';
import 'package:lucky_community/provider/community.dart';
import 'package:provider/provider.dart';

class SortSelector extends StatelessWidget {
  final List<Map<String, dynamic>> sortOptions = [
    {'id': 1, 'title': '最新发布'},
    {'id': 2, 'title': '最多点赞'},
    {'id': 3, 'title': '最多评论'},
  ];

  SortSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        return IconButton(
          icon: const Icon(Icons.sort),
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
                          '排序方式',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Divider(),
                      ...sortOptions.map((option) {
                        final isSelected =
                            provider.currentSortId == option['id'];
                        return ListTile(
                          title: Text(option['title']),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () {
                            provider.setCurrentSort(option['id']);
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
