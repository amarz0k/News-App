import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:news_application/api/api_constants.dart';
import 'package:news_application/api/api_routes.dart';
import 'package:news_application/models/article_model.dart';
import 'package:news_application/models/source_model.dart';

class Api {
  static Future<List<SourceModel>> getAllSources() async {
    try {
      // final url = Uri.parse(
      //   "${ApiRoutes.baseUrl}/${ApiRoutes.topHeadlines}/${ApiRoutes.sources}?language=en&${ApiRoutes.apiKey}",
      // );

      final url = Uri.https(ApiRoutes.baseUrl, "v2/top-headlines/sources", {
        "language": "en",
        "apiKey": ApiConstants.apiKey,
      });

      final res = await http.get(url);

      final jsonData = json.decode(res.body);
      if (jsonData["sources"] is List && jsonData["sources"].isNotEmpty) {
        final List<SourceModel> sources = (jsonData["sources"] as List)
            .map((source) => SourceModel.fromJson(source))
            .toList();
        return sources;
      } else {
        log("No sources found");
        throw Exception("No sources found");
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<ArticleModel>> getArticles(String articleId) async {
    try {
      final url = Uri.https(ApiRoutes.baseUrl, "v2/everything", {
        "sources": articleId,
        "apiKey": ApiConstants.apiKey,
      });

      final res = await http.get(url);
      final jsonData = json.decode(res.body);

      // Add null safety check here
      if (jsonData["articles"] != null && jsonData["articles"] is List) {
        final List<ArticleModel> articles = (jsonData["articles"] as List)
            .map((article) => ArticleModel.fromJson(article))
            .toList();

        if (articles.isNotEmpty) {
          return articles;
        } else {
          throw Exception("No articles found");
        }
      } else {
        print(
          "API Response: $jsonData",
        ); // Debug: see what the API actually returns
        throw Exception("Invalid response format or no articles field");
      }
    } catch (e) {
      print("Error in getArticles: $e");
      return [];
    }
  }
}
