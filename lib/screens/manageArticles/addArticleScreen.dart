import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';

import '../../compositeWidgets/AddArticleForm.dart';

class AddArticleScreen extends StatelessWidget {
  const AddArticleScreen({this.baseArticle,Key? key, this.shouldAddArticle}) : super(key: key);

  final Article? baseArticle;
  final bool? shouldAddArticle;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(baseArticle == null ? "Ajouter un article" : "Modifer un article"),
      ),
      body: Column(
        children: [
          Flexible(
            child: AddArticleForm(scaffoldKey : scaffoldKey, baseArticle : baseArticle, shouldAddArticle: shouldAddArticle),
          ),
        ],
      ),
    );
  }
}
