import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucky_community/page/home/latest.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              // 搜索框
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '搜索: 知识库、用户、文章',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 242, 242, 245), // 背景色
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none, // 去掉边框线
                    ),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.grey), // 搜索图标
                  ),
                ),
              ),
              const SizedBox(width: 8), // 图标与搜索框间距
              // 右侧小按钮
              IconButton(
                icon: const Icon(Icons.settings), // 替换为所需的图标
                onPressed: () {
                  // TODO: 添加按钮的功能
                },
              ),
            ],
          ),
        ),
        // backgroundColor: const Color.fromARGB(255, 106, 229, 129), // AppBar 背景色
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner 部分
            SizedBox(
              height: 160, // Banner 高度
              child: PageView(
                children: [
                  // 这里可以放置你的轮播图图片
                  Image.asset(
                    'assets/img/kc.png',
                    fit: BoxFit.fill,
                  ),
                  Image.asset(
                    'assets/img/banner2.png',
                    fit: BoxFit.fill,
                  ),
                  Image.asset(
                    'assets/img/banner3.png',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),

            // 课程列表部分
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromARGB(50, 230, 230, 230))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '课程列表',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement "更多" 按钮功能
                    },
                    child: const Text('更多'),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 8), // 间隔

            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(150, 230, 230, 230)))),
              height: 120, // 卡片高度
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // 替换为你的课程数量
                itemBuilder: (context, index) {
                  final random = Random();
                  int randomInt = 1 + random.nextInt(2);
                  return Padding(
                      padding: const EdgeInsets.only(top: 1, bottom: 2),
                      child: Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 6.0), // 减小间距
                        decoration: BoxDecoration(
                            color: Colors.white, // 背景颜色
                            borderRadius: BorderRadius.circular(8.0), // 圆角
                            border: Border.all(
                                color: const Color.fromARGB(150, 230, 230, 230))
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.1), // 阴影颜色和透明度
                            //     offset: const Offset(0, 1), // 阴影偏移
                            //     blurRadius: 1.0, // 模糊半径
                            //     spreadRadius: 1.0, // 扩散半径
                            //   ),
                            // ],
                            ),
                        width: 200, // 卡片宽度
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8.0), // 与 Container 的圆角一致
                          child: Image.asset(
                            'assets/img/kc$randomInt.jpeg',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ));
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom:
                        BorderSide(color: Color.fromARGB(150, 230, 230, 230))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '最新动态',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement "更多" 按钮功能
                    },
                    child: const Text('更多'),
                  ),
                ],
              ),
            ),
            // 最新文章部分
            const LatestPage(),
          ],
        ),
      ),
    );
  }
}
