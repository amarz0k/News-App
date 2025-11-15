import 'package:flutter/material.dart';
import 'package:news_application/api/api.dart';
import 'package:news_application/constants/app_style.dart';
import 'package:news_application/utils/custom_search.dart';
import 'package:news_application/widgets/news_widget.dart';

class SourcePage extends StatefulWidget {
  final String sourceId;
  final String sourceName;
  const SourcePage(this.sourceId, this.sourceName, {super.key});

  @override
  State<SourcePage> createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  int _retryKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(widget.sourceName, style: AppStyle.text26Bold),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearch());
            },
            icon: const Icon(Icons.search, size: 30),
          ),
        ],
      ),
      body: FutureBuilder(
        key: ValueKey(_retryKey),
        future: Api.getArticles(widget.sourceId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
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
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _retryKey++;
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final articles = snapshot.data;
            if (articles != null && articles.isNotEmpty) {
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return NewsWidget(articles: articles, index: index);
                },
              );
            } else {
              return const Center(child: Text("No articles found"));
            }
          }
        },
      ),
    );
  }
}
