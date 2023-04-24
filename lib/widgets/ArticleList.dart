import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Image.network(article.picture, fit: BoxFit.scaleDown, width: 1,),
            title: Text(article.name),
            subtitle: Text(article.articleCode),
            trailing: const Icon(Icons.delete),
            onTap: () {
              // Navigate to article 1
            },
          ),
        ],
      ),
    );
  }
}
