import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/providers/order_provider.dart';
import 'package:proj1/screens/createOrder/confirmOrderScreen.dart';
import 'package:proj1/screens/createOrder/scanArticleScreen.dart';
import 'package:proj1/widgets/articleList.dart';
import 'package:proj1/widgets/largeButton.dart';
import 'package:proj1/widgets/quantityForm.dart';

import '../../widgets/cartAppBar.dart';
import '../manageArticles/addArticleScreen.dart';

class SetArticleQuantity extends ConsumerStatefulWidget {
  const SetArticleQuantity({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  ConsumerState<SetArticleQuantity> createState() => _SetArticleQuantityState();
}

class _SetArticleQuantityState extends ConsumerState<SetArticleQuantity> {
  double chosenQuantity = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setQuantity(double newQuantity) {
    setState(() {
      chosenQuantity = newQuantity;
    });
  }

  void _createNewOrderLine() {
    ref.read(orderProvider.notifier).addOrderLine(
        article: widget.article, quantity: chosenQuantity, discount: 0);
  }

  void validateQuantity() {
    _createNewOrderLine();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (ctx) => const ConfirmOrderScreen()));
  }

  void addNewLine() {
    _createNewOrderLine();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (ctx) => const ScanArticleScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrez la quantité"),
        actions: const [
          CartAppBar(),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ArticleList(
                showArticlePrice: true,
                article: widget.article,
                onClick: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          AddArticleScreen(baseArticle: widget.article)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              QuantityForm(
                articlePrice: widget.article.price,
                setQuantity: setQuantity,
                autoFocus: true,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                LargeButton(
                  label: "Ajouter",
                  color: Colors.greenAccent,
                  onClick: addNewLine,
                ),
                const SizedBox(height: 8),
                LargeButton(
                  label: "Valider",
                  color: Colors.pinkAccent,
                  onClick: validateQuantity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
