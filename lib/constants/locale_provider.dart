import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale("en");

  Locale get locale => _locale;

  void chnageLocale(String lang) {
    if (lang.toLowerCase() == "en") {
      _locale = const Locale("en");
    } else if (lang.toLowerCase() == "ar") {
      _locale = const Locale("ar");
    }
    notifyListeners();
  }
}
