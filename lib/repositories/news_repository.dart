import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/news_article_model.dart';
import 'package:http/http.dart' as http;

const apiKey = "e65ee0938a2a43ebb15923b48faed18d";
const pageSize = 15;
const allNews = "everything";
const latestNews = "top-headlines";

class NewsRespository {
  Future<List<NewsArticleModel>> getAllNews([int page = 1]) async {
    var response = await http.get(Uri.parse(
        "https://newsapi.org/v2/$allNews?q=apple&page=$page&pageSize=$pageSize&from=2021-10-15&sortBy=popularity&apiKey=$apiKey"));
    var data = jsonDecode(response.body);

    List<NewsArticleModel> _newsArticleList = [];

    if (response.statusCode == 200) {
      for (var item in data["articles"]) {
        NewsArticleModel _newsArticleModel = NewsArticleModel.fromJson(item);
        _newsArticleList.add(_newsArticleModel);
      }
      return _newsArticleList;
    } else {
      return _newsArticleList;
    }
  }

  Future<List<NewsArticleModel>> getLatestNews() async {
    var response = await http.get(Uri.parse(
        "https://newsapi.org/v2/$latestNews?q=apple&pageSize=$pageSize&from=2021-10-15&sortBy=popularity&apiKey=$apiKey"));
    var data = jsonDecode(response.body);

    List<NewsArticleModel> _newsArticleList = [];

    if (response.statusCode == 200) {
      for (var item in data["articles"]) {
        NewsArticleModel _newsArticleModel = NewsArticleModel.fromJson(item);
        _newsArticleList.add(_newsArticleModel);
      }
      return _newsArticleList;
    } else {
      return _newsArticleList;
    }
  }

  Future<List<NewsArticleModel>> getSavedNews() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedNews = prefs.getStringList('savedNews');
    if (savedNews == null) {
      return [];
    } else {
      return savedNews
          .map((e) => NewsArticleModel.fromJson(jsonDecode(e)))
          .toList();
    }
  }

  Future<bool> saveArticle(NewsArticleModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final oldNews = await getSavedNews();
    // if item is present
    if (oldNews.contains(model)) {
      return false;
    }
    final latestNews = [...oldNews, model];
    final _set = latestNews.toSet().toList();
    return await prefs.setStringList(
        'savedNews', _set.map((n) => jsonEncode(n)).toList());
  }

  Future<bool> removeArticle(NewsArticleModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final oldNews = await getSavedNews();
    final news = oldNews.toSet()
      ..remove(model)
      ..toList();
    return await prefs.setStringList(
        'savedNews', news.map((n) => jsonEncode(n)).toList());
  }
}
