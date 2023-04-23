

import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/widgets/ArticleList.dart';

class ListOfArticles extends StatelessWidget {
  ListOfArticles({Key? key}) : super(key: key);

  final Article article =  Article(name: "Tomates Frito");

  @override
  Widget build(BuildContext context) {
    return ArticleList(
        article: article
    );
  }
}
