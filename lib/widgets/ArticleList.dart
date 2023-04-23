import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(article.name),
    );
  }
}
