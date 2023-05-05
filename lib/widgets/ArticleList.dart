import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child : Card(
      elevation: 5,
      child: ListTile(
            leading: SizedBox(width: 100,child: Image.network(article.picture, fit: BoxFit.scaleDown, width: 100,),),
            title: Text(article.name),
            subtitle: Text(article.articleCode),
            trailing: const Icon(Icons.delete),
            onTap: () {
              // Navigate to article 1
            },
          ),
      ),
    );
  }
}
