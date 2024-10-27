import 'package:flutter/material.dart';
import 'package:lucky_community/layout/hello.dart';
import 'package:lucky_community/provider/article.dart';
import 'package:lucky_community/provider/home.dart';
import 'package:lucky_community/provider/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => ArticleProvider()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245)
      ),
      home: const HelloPage(),
    );
  }
}
