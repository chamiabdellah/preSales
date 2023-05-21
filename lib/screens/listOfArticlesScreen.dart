import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/widgets/ArticleList.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/providers/list_of_articles_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/Paths.dart';

class ListOfArticles extends ConsumerStatefulWidget {
  const ListOfArticles({super.key});

  @override
  ConsumerState<ListOfArticles> createState() => _ListOfArticlesState();
}

class _ListOfArticlesState extends ConsumerState<ListOfArticles> {
  List<Article> listOfArticle = [];

  Future<void> fetchArticles() async {
    String link = Paths.articlePath;
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
      ref.read(listOfArticlesProvider.notifier).state = loadedItems;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    listOfArticle = ref.watch(listOfArticlesProvider);
    return ListView.builder(
      itemCount: listOfArticle.length,
      itemBuilder: (context, index) {
        return ArticleList(article: listOfArticle[index]);
      },
    );
  }
}