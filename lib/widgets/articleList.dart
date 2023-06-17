import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/utils/Formaters.dart';

import 'imageNetworkCached.dart';

class ArticleList extends ConsumerWidget {
  const ArticleList({
    Key? key,
    required this.article,
    this.onDelete,
    this.onClick,
    this.showArticlePrice = false,
  }) : super(key: key);

  final Article article;
  final VoidCallback? onDelete;
  final VoidCallback? onClick;
  final bool showArticlePrice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SizedBox(
      height: 80,
      child: Card(
        elevation: 5,
        child: ListTile(
          key: ValueKey(article.id),
          leading: SizedBox(
            width: 60,
              child: ImageNetworkCached(imageUrl: article.picture)),
          title: Text(article.name),
          subtitle: Text(article.unit),
          trailing: showArticlePrice ?
            Text('${article.price.toMonetaryString()} DH', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),)
          : onDelete != null
              ? InkWell(
                  onTap: onDelete,
                  child: const Icon(
                    size: 30,
                    Icons.delete,
                    color: Colors.deepOrangeAccent,
                  ))
              : null,
          onTap: onClick,
        ),
      ),
    );
  }
}
