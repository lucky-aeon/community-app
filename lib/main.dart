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
import 'package:lucky_community/provider/theme_provider.dart';
import 'package:lucky_community/theme/app_theme.dart';

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
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Lucky Community',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const HelloPage(),
        );
      },
    );
  }
}
