import 'package:flutter/material.dart';
import 'package:lucky_community/layout/hello.dart';
import 'package:lucky_community/provider/article.dart';
import 'package:lucky_community/provider/comment.dart';
import 'package:lucky_community/provider/community.dart';
import 'package:lucky_community/provider/home.dart';
import 'package:lucky_community/provider/user.dart';
import 'package:provider/provider.dart';
import 'package:lucky_community/provider/auth.dart';
import 'package:lucky_community/provider/notification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => ArticleProvider()),
      ChangeNotifierProvider(create: (_) => CommunityProvider()),
      ChangeNotifierProvider(create: (_) => CommentProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const HelloPage(),
    );
  }
}
