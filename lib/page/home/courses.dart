import 'package:flutter/material.dart';
import 'package:lucky_community/api/base.dart';
import 'package:lucky_community/model/course.dart';
import 'package:lucky_community/page/course/detail.dart';
import 'package:lucky_community/provider/home.dart';
import 'package:lucky_community/widgets/course/list_item.dart';
import 'package:provider/provider.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String _selectedTechnology = '全部';
  String _sortBy = '最新';
  final List<String> _technologies = ['全部'];
  final List<String> _sortOptions = ['最新'];
  late HomeProvider providerHome;

  @override
  void initState() {
    super.initState();
    providerHome = Provider.of<HomeProvider>(context, listen: false);
    _loadCourses();
  }

  void _loadCourses() async {
    await providerHome.getCourseList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 筛选和排序栏
        Row(
          children: [
            // 技术筛选
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: DropdownButtonFormField<String>(
                  isDense: true,
                  isExpanded: true,
                  value: _selectedTechnology,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  items: _technologies.map((String tech) {
                    return DropdownMenuItem<String>(
                      value: tech,
                      child: Text(tech),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedTechnology = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 排序选项
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: DropdownButtonFormField<String>(
                  isDense: true,
                  isExpanded: true,
                  value: _sortBy,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  items: _sortOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _sortBy = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        // 课程列表
        Expanded(
          child: Consumer<HomeProvider>(
            builder: (context, provider, child) {
              final courses = provider.coursesList;
              
              if (courses.isEmpty) {
                return const Center(
                  child: Text('暂无课程'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await provider.getCourseList();
                },
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 360,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return CourseListItem(
                      course: course,
                      margin: EdgeInsets.zero,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 根据屏幕宽度确定网格列数
  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1100) {
      return 3;
    } else if (width > 700) {
      return 2;
    } else {
      return 1;
    }
  }

  // 构建课程卡片
  Widget _buildCourseCard(Course course) {
    return RepaintBoundary(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailPage(courseDetail: course),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 封面图片
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Hero(
                  tag: 'course_${course.id}',
                  child: course.cover.isEmpty
                      ? Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.school, size: 40, color: Colors.grey),
                          ),
                        )
                      : Image.network(
                          ApiBase.getUrlNoRequest(course.cover),
                          headers: {ApiBase.AuthorizationKey: ApiBase.token},
                          fit: BoxFit.cover,
                          cacheWidth: 800,
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) return child;
                            return AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              child: child,
                            );
                          },
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // 描述
                      Expanded(
                        child: Text(
                          course.desc,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 底部信息
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 观看数和评分
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.visibility_outlined,
                                    size: 14,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${course.views}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${course.score}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // 价格
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '¥${course.money}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
