import 'package:flutter/material.dart';
import 'package:news_application/constants/app_style.dart';
import 'package:news_application/l10n/app_localizations.dart';
import 'package:news_application/models/category_model.dart';
import 'package:news_application/pages/category_page.dart';
import 'package:news_application/utils/custom_search.dart';
import 'package:news_application/widgets/menu_drawer.dart';
import 'package:news_application/widgets/view_all_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> _categories = [];
  var searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _loadCategories() {
    _categories = CategoryModel.getCategories(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload categories when theme changes
    _loadCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.homePageTitle,
          style: AppStyle.text26Bold,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu, size: 30),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearch());
            },
            icon: const Icon(Icons.search, size: 30),
          ),
        ],
      ),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.homePageContentTitle,
                style: AppStyle.text26Bold,
              ),
              Text(
                AppLocalizations.of(context)!.homePageContentDescription,
                style: AppStyle.text26Bold,
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  bool isEven = index % 2 == 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                              _categories[index].id,
                              _categories[index].categoryName,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.black54),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                _categories[index].imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              right: isEven ? 16.0 : null,
                              left: isEven ? null : 16.0,
                              child: ViewAllButton(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
