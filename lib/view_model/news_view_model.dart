import 'package:news_app/Model/news_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

import 'categories_model.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsHeadlinesModel> fetchHeadlinesAPI(String name) async {
    final response = await _rep.fetchHeadlinesAPI(name);
    return response;
  }
}

class CategoryViewModel {
  final _rep = NewsRepository();

  Future<NewsCategoriesModel> fetchCategoriesAPi(String category) async {
    final response = await _rep.fetchCategoriesAPI(category);
    return response;
  }
}
