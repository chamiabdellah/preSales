import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/providers/list_of_deliv_orders.dart';

import '../../models/order.dart';
import '../../widgets/confirmOrders/orderList.dart';

class ListOfDeliverOrdersScreen extends ConsumerStatefulWidget {
  const ListOfDeliverOrdersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListOfDeliverOrdersScreen> createState() => _ListOfDeliverOrdersScreenState();
}

class _ListOfDeliverOrdersScreenState extends ConsumerState<ListOfDeliverOrdersScreen> {
  List<Order> listOrders = [];
  bool isLoading = false;
  bool failedLoading = false;

  void loadDelivOrders() async {
    setState(() {
      isLoading = true;
    });
    try{
      ref.read(listOfDeliverOrdersProvider.notifier).initOrdersListFromDb();
    } catch(e){
      setState(() {
        isLoading = false;
        failedLoading = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDelivOrders();
  }

  @override
  Widget build(BuildContext context) {
    listOrders = ref.watch(listOfDeliverOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scannez l\'article"),
      ),
      body: isLoading ?
      const Center(child: CircularProgressIndicator(),) :
      listOrders.isEmpty ? const Center(child : Text("aucune commande trouvée")) :
      ListView.builder(
          itemCount:  listOrders.length,
          itemBuilder: (context, index) {
            return OrderList(order: listOrders[index]);
          }),
    );
  }
}
