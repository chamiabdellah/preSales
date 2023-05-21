import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';

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

}

final listOfArticlesProvider = StateNotifierProvider<ListOfArticlesNotifier, List<Article>>((ref){
  return ListOfArticlesNotifier();
});