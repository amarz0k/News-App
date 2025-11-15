import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_application/api/api.dart';
import 'package:news_application/constants/app_style.dart';
import 'package:news_application/utils/custom_search.dart';
import 'package:news_application/widgets/news_widget.dart';

class CategoryPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const CategoryPage(this.categoryId, this.categoryName, {super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Map<String, String>> _tabs = [];
  String? _errorMessage; // Add this line

  @override
  void initState() {
    super.initState();
    getTabs();
  }

  Future<void> getTabs() async {
    try {
      final sources = await Api.getCategorySources(widget.categoryId);

      if (mounted) {
        setState(() {
          _tabs.clear();
          _tabs.addAll(sources.map((e) => {"id": e.id, "name": e.name}));
          _tabController?.dispose();
          _tabController = TabController(length: _tabs.length, vsync: this);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Show error state
          _tabs.clear();
          _errorMessage = e.toString(); // Add this line to store the error
        });
        // Remove the entire SnackBar block
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onTabTapped(int index) {
    setState(() {});
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 8) {
      // For older dates, return formatted date instead
      return DateFormat('MMM d, yyyy').format(date);
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return 'a day ago';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return 'an hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return 'a minute ago';
    } else {
      return 'just now';
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(widget.categoryName, style: AppStyle.text26Bold),

        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearch());
            },
            icon: const Icon(Icons.search, size: 30),
          ),
        ],
        bottom: _tabs.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  dividerColor: Colors.transparent,
                  labelStyle: AppStyle.text16Bold,
                  unselectedLabelStyle: AppStyle.text16Normal,
                  indicatorSize: TabBarIndicatorSize.label,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  splashFactory: NoSplash.splashFactory,
                  tabs: [for (final tab in _tabs) Tab(text: tab["name"])],
                  onTap: onTabTapped,
                ),
              ),
      ),
      body: _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading News',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                      });
                      getTabs();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
          : _tabs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                for (final tab in _tabs)
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: Api.getArticles(tab["id"]!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error loading articles:',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        snapshot.error.toString(),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              final articles = snapshot.data;
                              if (articles != null && articles.isNotEmpty) {
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: articles.length,
                                    itemBuilder: (context, index) {
                                      return NewsWidget(
                                        articles: articles,
                                        index: index,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text("No articles found"),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
