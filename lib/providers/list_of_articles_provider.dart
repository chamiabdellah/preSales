import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:http/http.dart' as http;

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

  Future<Article?> getArticleByCodeDB(String articleCode) async {
    try{
      final url = Uri.parse(Paths.getArticleByCodePath(articleCode));
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