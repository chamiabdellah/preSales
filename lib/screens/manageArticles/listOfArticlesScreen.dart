import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/utils/SecurePath.dart';
import 'package:proj1/widgets/articleList.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/providers/list_of_articles_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/Paths.dart';
import 'addArticleScreen.dart';

class ListOfArticles extends ConsumerStatefulWidget {
  const ListOfArticles({super.key});

  @override
  ConsumerState<ListOfArticles> createState() => _ListOfArticlesState();
}

class _ListOfArticlesState extends ConsumerState<ListOfArticles> {
  List<Article> listOfArticle = [];
  bool isLoading = false;
  bool isFailed = false;

  Future<void> fetchArticles() async {
    setState(() {
      isLoading = true;
    });
    String link = await SecurePath.appendToken(Paths.articlePath);
    Uri uri = Uri.parse(link);
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
          picture: value['image'],
          id: key,
        ));
      });
      // TODO : search for 'convex.com' as a firebase replacement
      ref.read(listOfArticlesProvider.notifier).state = loadedItems;
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isFailed = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void deleteArticle(BuildContext context, Article article) async {
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
        deleteArticleFromDatabase(article);
      }
    }
    );
  }

  void deleteArticleFromDatabase(Article article) async {
    final securePath = await SecurePath.appendToken(Paths.getArticlePathWithId(article.id));
    Uri uri = Uri.parse(securePath);

    final response = await http.delete(uri);
    if(response.statusCode == 200){
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('article_images')
          .child('${article.articleCode}${article.name}.jpeg');
      await storageRef.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    listOfArticle = ref.watch(listOfArticlesProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AddArticleScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child : Icon(
                size: 35,
                Icons.add,  // add custom icons also
              ),
            ),
          ),
        ],
        title: const Text("Liste des articles"),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) :
      isFailed ? ErrorWidget(Exception("failed to load the images")) :
      listOfArticle.isEmpty ? const Center(child: Text('Aucun article.'),) :
      ListView.builder(
        itemCount: listOfArticle.length,
        itemBuilder: (context, index) {
          return ArticleList(
              article: listOfArticle[index],
              onDelete: ()=> deleteArticle(context, listOfArticle[index]),
              onClick: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => AddArticleScreen(baseArticle: listOfArticle[index])),
              ),
          );
        },
      ),
    );
  }
}
