import 'package:flutter/material.dart';
import 'package:news_application/constants/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  void chnageTheme(String theme) {
    if (theme.toLowerCase() == "light") {
      _themeData = lightTheme;
    } else if (theme.toLowerCase() == "dark") {
      _themeData = darkTheme;
    }
    notifyListeners();
  }
}
