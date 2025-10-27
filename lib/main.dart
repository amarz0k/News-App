import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:news_application/constants/app_routes.dart';
import 'package:news_application/constants/locale_provider.dart';
import 'package:news_application/constants/theme.dart';
import 'package:news_application/constants/theme_provider.dart';
import 'package:news_application/l10n/app_localizations.dart';
import 'package:news_application/l10n/l10n.dart';
import 'package:news_application/pages/home_page.dart';
import 'package:news_application/pages/category_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.homePage,
      routes: {
        AppRoutes.homePage: (context) => HomePage(),
        AppRoutes.categoryPage: (context) => CategoryPage("general", "General"),
      },
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeData.brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }
}
