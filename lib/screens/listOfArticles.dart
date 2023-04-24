

import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/widgets/ArticleList.dart';

class ListOfArticles extends StatelessWidget {
  ListOfArticles({Key? key}) : super(key: key);

  final Article article =  Article(
      name: "Tomates Frito",
      picture: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.rgarciaandsons.com%2Fproducts%2Fsolis-tomate-frito-350g&psig=AOvVaw0rZ_CH8UpFFBKYNzJ-ELE9&ust=1682377493236000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCMjA3NiOwf4CFQAAAAAdAAAAABAE",
      articleCode: "12344567",
  );

  @override
  Widget build(BuildContext context) {
    return ArticleList(
        article: article
    );
  }
}
