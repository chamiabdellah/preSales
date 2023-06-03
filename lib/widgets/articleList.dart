import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';

class ArticleList extends ConsumerWidget {
  const ArticleList({
    Key? key,
    required this.article,
    this.onDelete,
    this.onClick,
  }) : super(key: key);

  final Article article;
  final VoidCallback? onDelete;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 80,
      child: Card(
        elevation: 5,
        child: ListTile(
          key: ValueKey(article.id),
          leading: SizedBox(
            width: 100,
            child: CachedNetworkImage(
              imageUrl: article.picture,
              fit: BoxFit.scaleDown,
              width: 100,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Text(article.name),
          subtitle: Text(article.articleCode),
          trailing: onDelete != null
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
