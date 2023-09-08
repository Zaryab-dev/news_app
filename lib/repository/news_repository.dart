import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/Model/news_headlines_model.dart';
import 'package:news_app/view_model/news_view_model.dart';

import '../view_model/categories_model.dart';

class NewsRepository {
  Future<NewsHeadlinesModel> fetchHeadlinesAPI(String name) async {
    final url =
        'https://newsapi.org/v2/top-headlines?sources=$name&apiKey=781657c9c3f345d980b06d40305f7a10';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsHeadlinesModel.fromJson(body);
    } else {
      throw 'Error';
    }
  }

  Future<NewsCategoriesModel> fetchCategoriesAPI(String category) async {
    final url =
        'https://newsapi.org/v2/everything?q=$category&apiKey=781657c9c3f345d980b06d40305f7a10';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsCategoriesModel.fromJson(body);
    } else {
      throw 'Error';
    }
  }
}
