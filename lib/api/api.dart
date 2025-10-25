import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:news_application/api/api_constants.dart';
import 'package:news_application/api/api_routes.dart';
import 'package:news_application/models/article_model.dart';
import 'package:news_application/models/source_model.dart';

class Api {
  static void checkApiRateLimit(Map<String, dynamic> data) {
    if (data["status"] == "error" && data["code"] == "rateLimited") {
      log("API Rate limit exceeded: ${data["message"]}");
      throw Exception("API Rate limit exceeded: ${data["message"]}");
    }
  }

  static Future<List<SourceModel>> getAllSources() async {
    try {
      final url = Uri.https(ApiRoutes.baseUrl, "v2/top-headlines/sources", {
        "apiKey": ApiConstants.apiKey,
      });

      final res = await http.get(url);
      final jsonData = await json.decode(res.body);

      checkApiRateLimit(jsonData);

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
      log("get sources error: $e");
      rethrow;
    }
  }

  static Future<List<ArticleModel>> getArticles(String articleId) async {
    try {
      final url = Uri.https(ApiRoutes.baseUrl, "v2/everything", {
        "sources": articleId,
        "apiKey": ApiConstants.apiKey,
      });

      final res = await http.get(url);
      final jsonData = await json.decode(res.body);

      checkApiRateLimit(jsonData);

      // Add null safety check here
      if (jsonData["articles"] != null && jsonData["articles"] is List) {
        final List<ArticleModel> articles = (jsonData["articles"] as List)
            .map((article) => ArticleModel.fromJson(article))
            .toList();

        return articles;
      } else {
        log("API Response: $jsonData");
        throw Exception("Invalid response format or no articles field");
      }
    } catch (e) {
      log("get articles error: $e");
      rethrow; // Change this from: return [];
    }
  }
}
