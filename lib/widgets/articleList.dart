import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/providers/list_of_articles_provider.dart';
import 'package:http/http.dart' as http;

import '../screens/addArticleScreen.dart';
import '../utils/Paths.dart';

class ArticleList extends ConsumerWidget {
  const ArticleList({Key? key, required this.article}) : super(key: key);

  final Article article;

  void deleteArticle(BuildContext context, WidgetRef ref) async {
    // 1 - remove the article from the articleList
    ref
        .read(listOfArticlesProvider.notifier)
        .deleteArticle(article.articleCode);

    // 2 - show a snack bar with cancel button
    SnackBar snackBar = SnackBar(
      content: Text("L'article ${article.name} a été supprimé"),
      action: SnackBarAction(
        label: "Annuler",
        onPressed: () {
          ref.read(listOfArticlesProvider.notifier).addArticle(article);
        },
      ),
      duration: const Duration(seconds: 7),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((SnackBarClosedReason reason) {
        if(reason != SnackBarClosedReason.action){
          deleteArticleFromDatabase();
        }
      }
    );

    // 3 - after snack bar timeout send the request to delete the article

    // 4 - on action add the article back, and cancel the deletion request
  }

  void deleteArticleFromDatabase() async {
    Uri uri = Uri.parse(Paths.getArticlePathWithId(article.id));

    final response = await http.delete(uri);
    if(response.statusCode == 200){
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('article_images')
          .child('${article.articleCode}${article.name}.jpeg');
      await storageRef.delete();
    }
  }

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
            child: Image.network(
              article.picture,
              fit: BoxFit.scaleDown,
              width: 100,
            ),
          ),
          title: Text(article.name),
          subtitle: Text(article.articleCode),
          trailing: InkWell(
              onTap: () => deleteArticle(context, ref),
              child: const Icon(
                size: 30,
                Icons.delete,
                color: Colors.deepOrangeAccent,
              )),
          onTap: () {
            // Navigate to article 1
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => AddArticleScreen(baseArticle: article)));
          },
        ),
      ),
    );
  }
}
