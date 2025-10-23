import 'package:flutter/material.dart';
import 'package:news_application/constants/app_routes.dart';
import 'package:news_application/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.homePage,
      routes: {AppRoutes.homePage: (context) => HomePage()},
    );
  }
}
