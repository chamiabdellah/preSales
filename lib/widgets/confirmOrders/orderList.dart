import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proj1/screens/confirmOrders/orderDetailsScreen.dart';
import 'package:proj1/utils/Formaters.dart';

import '../../models/order.dart';

class OrderList extends StatelessWidget {
  const OrderList({Key? key ,required this.order}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => OrderDetailsScreen(order: order)));
      },
      child: Card(
        elevation: 20,
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: [
                      Text(order.orderNumber ?? "NaN"),
                      Text(order.customer.name),
                      Text(DateFormat.yMMMMEEEEd('fr_FR').format(order.creationDate!).toString()),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  children: [
                    Text('Total à payer : ${order.totalCost.toMonetaryString()} DH'),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: Text("${order.listOrderLines.length} article",
                  textAlign: TextAlign.center,),
                ),
              )
            ],
          ),
      ),
    );
  }
}
