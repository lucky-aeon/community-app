import 'package:flutter/material.dart';
import 'package:lucky_community/layout/hello.dart';
import 'package:lucky_community/provider/article.dart';
import 'package:lucky_community/provider/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ArticleListProvider())
      ],
      child: const MainApp(),
    ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: HelloPage(),
      ),
    );
  }
}
