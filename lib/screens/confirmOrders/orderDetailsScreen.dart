import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/providers/list_of_confirm_orders.dart';
import 'package:proj1/utils/LoadingIndicator.dart';
import 'package:proj1/widgets/confirmOrders/orderLineDetails.dart';
import 'package:proj1/widgets/confirmOrders/orderList.dart';
import 'package:proj1/widgets/largeButton.dart';

import '../../models/order.dart';
import '../../models/order_line.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  final Order order;

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {

  late Order order;
  bool isLoading = false;
  bool failed = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  void confirmOrderLine(String index, double foundQuantity){
    order.listOrderLines.firstWhere((ordLine) => ordLine.index == index).availableQuantity = foundQuantity;
    for(OrderLine ordLine in order.listOrderLines){
      if(ordLine.index == index){
        ordLine.availableQuantity = foundQuantity;
        break;
      }
    }
  }

  void validateOrderConfirmation() async {
    setState(() {
      isLoading = true;
    });
    LoadingIndicator.showLoadingIndicator(context, "Confirmation de la commande");
    try{
      await ref.read(listOfConfirmOrdersProvider.notifier).confirmOrder(order);
    } catch(e){
      setState(() {
        isLoading = false;
        failed = true;
      });
    }
    setState(() {
      isLoading = false;
    });

    if(!mounted) return;
    LoadingIndicator.hideLoadingIndicator(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details de la commande"),
      ),
      body: Column(
        children: [
          OrderList(order: order),
          Expanded(
              child: ListView.builder(
                itemCount: order.listOrderLines.length,
                  itemBuilder: (ctx, index){
                    return OrderLineDetails(
                        orderLine: order.listOrderLines[index],
                        onChecked : confirmOrderLine,
                    );
                  })
          ),
          LargeButton(
            label: 'Confirmer',
            color: Colors.redAccent,
            onClick: validateOrderConfirmation,
          ),
        ],
      )
    );
  }
}
