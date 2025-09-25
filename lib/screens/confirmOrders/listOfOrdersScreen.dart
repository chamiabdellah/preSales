import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proj1/providers/list_of_confirm_orders.dart';
import 'package:proj1/widgets/confirmOrders/orderList.dart';
import 'package:proj1/widgets/emptyListInfo.dart';

import '../../models/order.dart';

class ListOfOrdersScreen extends ConsumerStatefulWidget {
  const ListOfOrdersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListOfOrdersScreen> createState() => _ListOfOrdersScreenState();
}

class _ListOfOrdersScreenState extends ConsumerState<ListOfOrdersScreen> {
  List<Order> listOrders = [];
  bool isLoading = false;
  bool failedLoading = false;

  void fetchConfirmOrder() async {
    setState(() {
      isLoading = true;
    });
    try{
      await ref.read(listOfConfirmOrdersProvider.notifier).initOrdersListFromDb();

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
    fetchConfirmOrder();
  }

  @override
  Widget build(BuildContext context) {
    listOrders = ref.watch(listOfConfirmOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des commandes"),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) :
      listOrders.isEmpty ? const EmptyListInfo(message: "aucune commande trouvée") :
      failedLoading ? const EmptyListInfo(message: "Impossible de récuperer les commandes !!!") :
      ListView.builder(
        itemCount:  listOrders.length,
          itemBuilder: (context, index) {
            return OrderList(order: listOrders[index]);
          }),
    );
  }
}
