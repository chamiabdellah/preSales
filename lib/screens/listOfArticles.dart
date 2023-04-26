import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/widgets/ArticleList.dart';
import 'package:http/http.dart' as http;

class ListOfArticles extends StatefulWidget{
  const ListOfArticles({super.key});

  @override
  State<StatefulWidget> createState() => _ListOfArticlesState();
}

class _ListOfArticlesState extends State<ListOfArticles> {

  final Article article =  Article(
      name: "Tomates Frito",
      picture: "https://cdn.shopify.com/s/files/1/0509/4876/7952/products/solistomatefrito1_940x.jpg?v=1614358995",
      articleCode: "12344567",
  );

  List<Article> listOfArticle = [];

  Future<void> fetchArticles() async {
    String link = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Articles.json";
    Uri uri =Uri.parse(link);
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
            picture: value['image']
        ));
      });
      setState(() {
        listOfArticle = loadedItems;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    listOfArticle = [];
    fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount:listOfArticle.length, itemBuilder: (context, index){
      return ArticleList(article: listOfArticle[index]);
    });

  }
}
