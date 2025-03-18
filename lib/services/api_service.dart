import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ApiService {
  static const String apiKey = 'b3de71a1fc71424d9f1af6dcf02004e8'; // Replace with your API key
  static const String baseUrl = 'https://newsapi.org/v2';

  static Future<List<Article>> fetchNews({String category = 'general'}) async {
    final url = Uri.parse('$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['articles'];
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
