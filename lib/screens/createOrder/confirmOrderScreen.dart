import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/providers/list_of_articles_provider.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/providers/order_provider.dart';
import 'package:proj1/screens/createOrder/SearchOrScanArticle.dart';
import 'package:proj1/screens/createOrder/orderRecapScreen.dart';
import 'package:proj1/screens/createOrder/scanArticleScreen.dart';
import 'package:proj1/utils/Formaters.dart';
import 'package:proj1/utils/LoadingIndicator.dart';
import 'package:proj1/widgets/emptyListInfo.dart';
import 'package:proj1/widgets/largeButton.dart';
import 'package:proj1/widgets/quantityForm.dart';

import '../../models/customer.dart';
import '../../models/order.dart';
import '../../models/order_line.dart';
import '../../widgets/articleList.dart';

class ConfirmOrderScreen extends ConsumerStatefulWidget {
  const ConfirmOrderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends ConsumerState<ConfirmOrderScreen> {
  Order? order;
  bool isLoading = false;
  bool isFailed = false;

  void deleteOrderLineFromOrder(OrderLine orderLine) {
    ref.read(orderProvider.notifier).deleteOrderLine(orderLine);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // initTestData();
  }

  void setOrderLineQuantity(OrderLine orderLine, double newQuantity) {
    ref
        .read(orderProvider.notifier)
        .setQuantityOrderLine(orderLine: orderLine, newQuatity: newQuantity);
    setState(() {});
  }

  void initTestData() async {
    // test data
    Customer customer = ref.read(listOfCustomersProvider).first;
    Article artilcleTest = ref.read(listOfArticlesProvider).first;
    OrderLine orderLine1 = OrderLine(
        article: artilcleTest, index: "1", quantity: 0, totalPrice: 0);
    artilcleTest = ref.read(listOfArticlesProvider).last;
    OrderLine orderLine2 = OrderLine(
        article: artilcleTest, index: "2", quantity: 0, totalPrice: 0);
    Order localOrder =
          Order(customer: customer, listOrderLines: [orderLine1, orderLine2]);

    ref.read(orderProvider.notifier).state = localOrder;
  }

  void createOrder() async {
    LoadingIndicator.showLoadingIndicator(context, "Confirmation de la commande");
    await ref.read(orderProvider.notifier).saveOrder();
    if(mounted){
      LoadingIndicator.hideLoadingIndicator(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => OrderRecapScreen(order: order)));
    }
  }

  @override
  Widget build(BuildContext context) {
    order = ref.watch(orderProvider);

    final List<OrderLine> orderLines = order?.listOrderLines ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmez la commande"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const SearchOrScanArticle()));
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
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromRGBO(248, 248, 248, 1.0),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  'Total : ${order?.calculateTotalCost().toMonetaryString() ?? 0} DH',
                  style: const TextStyle(
                      fontSize: 30, color: Color.fromRGBO(213, 82, 105, 1.0)),
                ),
              ),
              Flexible(
                child:
                orderLines.isEmpty ?
                const EmptyListInfo(message: "Ajoutez une ligne à la commande")
                : ListView.builder(
                  itemCount: orderLines.length,
                  itemBuilder: (context, index) {
                    return Column(
                      key: ValueKey(orderLines[index].index),
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 10,
                              child: ArticleList(
                                article: orderLines[index].article,
                                showArticlePrice: true,
                              ),
                            ),
                            Flexible(
                              child: IconButton.outlined(
                                icon: const Icon(Icons.cancel_outlined),
                                color: Colors.grey,
                                onPressed: () =>
                                    deleteOrderLineFromOrder(orderLines[index]),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 3),
                          height: 70,
                          child: QuantityForm(
                            articlePrice: orderLines[index].article.price,
                            initQuantity: orderLines[index].quantity,
                            setQuantity: (qtt) =>
                                setOrderLineQuantity(orderLines[index], qtt),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              LargeButton(
                label: "Confirmer",
                color: const Color.fromRGBO(23, 2, 32, 2),
                onClick: orderLines.isEmpty ? null : createOrder,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
