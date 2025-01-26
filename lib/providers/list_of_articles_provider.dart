import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/services/SecureStorageService.dart';
import 'package:proj1/utils/SecurePath.dart';

import '../utils/Paths.dart';

class ListOfArticlesNotifier extends StateNotifier<List<Article>>{
  ListOfArticlesNotifier() : super([]);

  void addArticle(Article article){
    state = [...state, article];
  }

  void deleteArticle(String code){
    state = state.where((element) => element.articleCode != code).toList();
  }

  void modifyArticle(Article newArticle, String code){
    deleteArticle(code);
    addArticle(newArticle);
  }

  Article getArticleByCode(String code){
    return state.firstWhere((element) => element.articleCode == code);
  }

  Future<List<Article>> fetchArticles() async {
    String link = await SecurePath.appendToken(Paths.articlePath);
    Uri uri = Uri.parse(link);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Article> loadedItems = [];
      extractedData.forEach((key, value) {
        loadedItems.add(Article(
          name: value['articleName'],
          articleCode: value['articleCode'],
          unit: value['unit'],
          quantity: value['quantity'].toDouble(),
          price: value['price'].toDouble(),
          picture: value['image'],
          id: key,
        ));
      });
      state = loadedItems;
      return loadedItems;
    } else {
      throw Exception("error during fetching the articles");
    }
  }

  Future<Article?> getArticleByCodeDB(String articleCode) async {
    try{
      final token = await SecureStorageService().getJwtToken();
      final securedPath = await SecurePath.appendToken(Paths.getArticleByCodePath(articleCode, token));
      final url = Uri.parse(securedPath);
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      Article dataBaseArticle = Article.fromJson(extractedData.entries.single);
      return dataBaseArticle;
    } catch (e){
      return null;
    }
  }

}

final listOfArticlesProvider = StateNotifierProvider<ListOfArticlesNotifier, List<Article>>((ref){
  return ListOfArticlesNotifier();
});