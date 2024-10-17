import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/providers/list_of_articles_provider.dart';
import 'package:proj1/screens/createOrder/scanArticleScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/screens/createOrder/setArticleQuatityScreen.dart';
import 'package:proj1/widgets/articleList.dart';

class SearchArticleScreen extends ConsumerStatefulWidget {
  const SearchArticleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchArticleScreen> createState() => _SearchArticleScreenState();
}

class _SearchArticleScreenState extends ConsumerState<SearchArticleScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Article> allArticles = [];
  List<Article> filteredArticles = [];
  bool isLoading = false;
  bool fetchFailed = false;
  bool searchMode = false;

  @override
  void initState() {

    super.initState();
    fetchArticles();
  }

  void fetchArticles() async {
    setState(() => isLoading = true );

    try{
      List<Article> articles = await ref.read(listOfArticlesProvider.notifier).fetchArticles();
      print(articles);
      setState(() {
        filteredArticles = allArticles = articles;
        isLoading = false;
      });
    } on Exception catch(_) {
      setState(() {
        isLoading = false;
        fetchFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chercher un produit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.barcode_reader),
            onPressed: () =>
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const ScanArticleScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              hintText: 'produit...',
              leading: const Icon(Icons.search),
              shape: const WidgetStatePropertyAll(BeveledRectangleBorder()),
              trailing: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ],
              onChanged: (value) {
                // Perform search as user types
                print('Searching for: $value');
                print(allArticles);
              },
              onSubmitted: (value) {
                // Perform search when user presses enter
                print('Search submitted: $value');
              },
            ),
            Expanded(child: allArticles.isNotEmpty ? ListView.builder(
              itemCount: allArticles.length,
              itemBuilder: (context, index) {
                return ArticleList(
                  article: allArticles[index],
                  onClick: ()=> Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => SetArticleQuantity(article: allArticles[index])),
                  ),
                );
              },
            ) : Expanded(
              child: Center(
                child: Text(fetchFailed ? 'The articles fetch failed...' : 'Search results will appear here...'),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
