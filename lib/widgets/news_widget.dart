import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_application/constants/app_style.dart';
import 'package:news_application/models/article_model.dart';
import 'package:news_application/utils/format_date.dart';

class NewsWidget extends StatelessWidget {
  final List<ArticleModel> articles;
  final int index;
  const NewsWidget({super.key, required this.articles, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black54),
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
          Text(articles[index].title, style: AppStyle.black16Bold),
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
    );
  }
}
