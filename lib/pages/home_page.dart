import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_application/api/api.dart';
import 'package:news_application/constants/app_style.dart';
import 'package:news_application/models/source_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Map<String, String>> _tabs = [];
  final List<SourceModel> _sources = [];

  @override
  void initState() {
    super.initState();
    getTabs();
  }

  Future<void> getTabs() async {
    final sources = await Api.getAllSources();

    if (mounted) {
      setState(() {
        _tabs.clear();
        _tabs.addAll(sources.map((e) => {"id": e.id, "name": e.name}));
        _tabController?.dispose();
        _tabController = TabController(length: _tabs.length, vsync: this);
      });
      _sources.addAll(sources);
    }
  }


  void onTabTapped(int index) {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("General", style: AppStyle.black26Bold),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  dividerColor: Colors.transparent,
                  labelStyle: AppStyle.black16Bold,
                  unselectedLabelStyle: AppStyle.black16Bold,
                  indicatorSize: TabBarIndicatorSize.label,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  splashFactory: NoSplash.splashFactory,
                  tabs: [for (final tab in _tabs) Tab(text: tab["name"])],
                  onTap: onTabTapped,
                ),
              ),
      ),
      body: _tabs.isEmpty || _sources.isEmpty
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
                                child: Text(
                                  snapshot.error.toString(),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
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
                                      return Container(
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    articles[index].urlToImage,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              articles[index].title,
                                              style: AppStyle.black16Bold,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "by: ${articles[index].author}",
                                                  style: AppStyle.grey16Normal,
                                                ),
                                                Text(
                                                  "a day ago",
                                                  style: AppStyle.grey12Bold,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
