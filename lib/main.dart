import 'package:flutter/material.dart';
import 'package:news_application/constants/app_routes.dart';
import 'package:news_application/constants/theme.dart';
import 'package:news_application/constants/theme_provider.dart';
import 'package:news_application/pages/home_page.dart';
import 'package:news_application/pages/category_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.homePage,
          routes: {
            AppRoutes.homePage: (context) => HomePage(),
            AppRoutes.categoryPage: (context) => CategoryPage("general"),
          },
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeData.brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    );
  }
}
