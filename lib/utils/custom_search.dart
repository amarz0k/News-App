import 'package:flutter/material.dart';
import 'package:news_application/api/api.dart';
import 'package:news_application/constants/app_style.dart';
import 'package:news_application/models/category_model.dart';
import 'package:news_application/models/source_model.dart';
import 'package:news_application/pages/category_page.dart';
import 'package:news_application/pages/source_page.dart';

class CustomSearch extends SearchDelegate {
  List<String> categories = [
    "Business",
    "Entertainment",
    "General",
    "Health",
    "Science",
    "Sports",
    "Technology",
  ];

  // Helper method to get category ID and localized name
  Map<String, String>? getCategoryInfo(
    BuildContext context,
    String categoryName,
  ) {
    final categories = CategoryModel.getCategories(context);
    // Map English category name to ID (lowercase)
    final categoryIdMap = {
      "Business": "business",
      "Entertainment": "entertainment",
      "General": "general",
      "Health": "health",
      "Science": "science",
      "Sports": "sports",
      "Technology": "technology",
    };

    final categoryId = categoryIdMap[categoryName];
    if (categoryId == null) return null;

    // Find the category with matching ID to get localized name
    final category = categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => CategoryModel(
        id: categoryId,
        categoryName: categoryName,
        imageUrl: '',
      ),
    );

    return {'id': categoryId, 'name': category.categoryName};
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ""; // clears the search input
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // closes the search delegate
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text("Results for: $query"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = categories.where((cat) {
      return cat.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (query.isEmpty) {
      return FutureBuilder<List<SourceModel>>(
        future: Api.getAllSources(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final List<SourceModel> sources = snapshot.data!;

          // Build list of widgets with headers
          List<Widget> items = [];

          if (suggestions.isNotEmpty) {
            items.add(
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Categories", style: AppStyle.text26Bold),
              ),
            );
            items.addAll(
              suggestions.map((cat) {
                final categoryInfo = getCategoryInfo(context, cat);
                return ListTile(
                  title: Text(cat, style: AppStyle.text16Normal),
                  onTap: () {
                    if (categoryInfo != null) {
                      close(context, null);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryPage(
                            categoryInfo['id']!,
                            categoryInfo['name']!,
                          ),
                        ),
                      );
                    }
                  },
                );
              }),
            );
          }

          if (sources.isNotEmpty) {
            items.add(
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Sources", style: AppStyle.text26Bold),
              ),
            );
            items.addAll(
              sources.map(
                (source) => ListTile(
                  title: Text(source.name, style: AppStyle.text16Normal),
                  onTap: () {
                    close(context, null);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SourcePage(source.id, source.name),
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          );
        },
      );
    }

    return FutureBuilder<List<SourceModel>>(
      future: Api.getAllSources(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }

        List<SourceModel> filteredSources = snapshot.data!.where((source) {
          return source.name.toLowerCase().contains(query.toLowerCase());
        }).toList();

        if (suggestions.isEmpty && filteredSources.isEmpty) {
          return Center(child: Text("No results found"));
        }

        // Build list of widgets with headers
        List<Widget> items = [];

        if (suggestions.isNotEmpty) {
          items.add(
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Categories", style: AppStyle.text26Bold),
            ),
          );
          items.addAll(
            suggestions.map((cat) {
              final categoryInfo = getCategoryInfo(context, cat);
              return ListTile(
                title: Text(cat, style: AppStyle.text16Normal),
                onTap: () {
                  if (categoryInfo != null) {
                    close(context, null);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(
                          categoryInfo['id']!,
                          categoryInfo['name']!,
                        ),
                      ),
                    );
                  }
                },
              );
            }),
          );
        }

        if (filteredSources.isNotEmpty) {
          items.add(
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Sources", style: AppStyle.text26Bold),
            ),
          );
          items.addAll(
            filteredSources.map(
              (source) => ListTile(
                title: Text(source.name, style: AppStyle.text16Normal),
                onTap: () {
                  close(context, null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SourcePage(source.id, source.name),
                    ),
                  );
                },
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => items[index],
        );
      },
    );
  }
}
