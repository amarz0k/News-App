import 'package:flutter/material.dart';
import 'package:news_application/constants/theme_provider.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    String selectedLanguage = "English";
    String selectedTheme =
        Provider.of<ThemeProvider>(context).themeData.brightness ==
            Brightness.light
        ? "Light"
        : "Dark";

    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColorDark,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(
                    "News App",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.home,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Go To Home",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 1,
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.palette,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Theme",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTheme,
                          isExpanded: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          dropdownColor: Colors.grey[800],
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "Light",
                              child: Text("Light"),
                            ),
                            DropdownMenuItem(
                              value: "Dark",
                              child: Text("Dark"),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedTheme = newValue;
                                Provider.of<ThemeProvider>(
                                  context,
                                  listen: false,
                                ).chnageTheme(newValue);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Divider(
                      color: Theme.of(context).primaryColor,
                      thickness: 1,
                    ),

                    const SizedBox(height: 24),
                    // Language section with dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Language",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedLanguage,
                              isExpanded: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              dropdownColor: Colors.grey[800],
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "English",
                                  child: Text("English"),
                                ),
                                DropdownMenuItem(
                                  value: "Spanish",
                                  child: Text("Spanish"),
                                ),
                                DropdownMenuItem(
                                  value: "French",
                                  child: Text("French"),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedLanguage = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
