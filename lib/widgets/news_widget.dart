import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_application/constants/app_style.dart';
import 'package:news_application/models/article_model.dart';
import 'package:news_application/pages/article_webview_page.dart';
import 'package:news_application/utils/format_date.dart';

class NewsWidget extends StatelessWidget {
  final List<ArticleModel> articles;
  final int index;
  const NewsWidget({super.key, required this.articles, required this.index});

  void _showArticleModal(BuildContext context, ArticleModel article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article Image
                      if (article.urlToImage.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: article.urlToImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error, size: 50),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Title
                      Text(article.title, style: AppStyle.text26Bold),
                      const SizedBox(height: 12),
                      // Author and Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "by: ${article.author.isNotEmpty ? article.author : 'Unknown'}",
                              style: AppStyle.grey16Normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatDate(article.publishedAt),
                            style: AppStyle.grey12Bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Source
                      if (article.sourceName.isNotEmpty)
                        Text(
                          "Source: ${article.sourceName}",
                          style: AppStyle.grey16Normal,
                        ),
                      const SizedBox(height: 16),
                      // Description
                      if (article.description.isNotEmpty)
                        Text(article.description, style: AppStyle.text16Normal),
                      const SizedBox(height: 16),
                      // Content
                      if (article.content.isNotEmpty)
                        Text(article.content, style: AppStyle.text16Normal),
                      const SizedBox(height: 24),
                      // Open in Browser Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleWebViewPage(
                                  url: article.url,
                                  title: article.title,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.open_in_browser,
                            color: Colors.green,
                          ),
                          label: const Text(
                            'Open in Browser',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showArticleModal(context, articles[index]),
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: articles[index].urlToImage,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 8),
            Text(articles[index].title, style: AppStyle.text16Bold),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "by: ${articles[index].author}",
                    style: AppStyle.grey16Normal,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  formatDate(articles[index].publishedAt),
                  style: AppStyle.grey12Bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
