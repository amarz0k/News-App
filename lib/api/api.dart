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

  static Future<List<SourceModel>> getCategorySources(String category) async {
    try {
      final url = Uri.https(ApiRoutes.baseUrl, "v2/top-headlines/sources", {
        "category": category,
        "apiKey": ApiConstants.apiKey,
      });

      log(url.toString());

      final res = await http.get(url);
      final jsonData = await json.decode(res.body);

      checkApiRateLimit(jsonData);

      if (jsonData["sources"] != null && jsonData["sources"] is List) {
        final List<SourceModel> sources = (jsonData["sources"] as List)
            .map((article) => SourceModel.fromJson(article))
            .toList();

        return sources;
      } else {
        throw Exception("Invalid data format received from API");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<List<ArticleModel>> getArticles(
    String sourceId,
    String category,
  ) async {
    try {
      final url = Uri.parse("https://${ApiRoutes.baseUrl}/v2/top-headlines?sources=$sourceId?category=$category&apiKey=${ApiConstants.apiKey}");

      final res = await http.get(url);
      final jsonData = await json.decode(res.body);

      checkApiRateLimit(jsonData);

      if (jsonData["articles"] != null && jsonData["articles"] is List) {
        final List<ArticleModel> articles = (jsonData["articles"] as List)
            .map((article) => ArticleModel.fromJson(article))
            .toList();

        return articles;
      } else {
        throw Exception("Invalid data format received from API");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
