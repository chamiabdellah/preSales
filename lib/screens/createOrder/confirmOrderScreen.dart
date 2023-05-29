
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/providers/order_provider.dart';

import '../../models/order.dart';
import '../../models/order_line.dart';
import '../../widgets/articleList.dart';

class ConfirmOrderScreen extends ConsumerWidget {
  const ConfirmOrderScreen({Key? key}) : super(key: key);
  
  void deleteArticleFromOrder(Article article, Order order, WidgetRef ref){
    final OrderLine orderLine = order.listOrderLines.firstWhere((element) => element.article.id == article.id);
    ref.read(orderProvider.notifier).deleteOrderLine(orderLine);
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Order? order = ref.watch(orderProvider);
    final List<Article> listOfArticle = order!.listOrderLines.map((e) => e.article).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmez la commande"),
      ),
      body: Column(
        children: [
          Center(
            child: ListView.builder(
              itemCount: listOfArticle.length,
              itemBuilder: (context, index) {
                return ArticleList(
                  article: listOfArticle[index],
                  onDelete: ()=> deleteArticleFromOrder(listOfArticle[index], order, ref),
                );
              },
            ),
          ),
          const SizedBox(height: 20,),
          Text('Cout Total : ${order.calculateTotalCost()}'),
        ],
      ),
    );
  }
}
