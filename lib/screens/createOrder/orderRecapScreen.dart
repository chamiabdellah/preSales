import 'package:flutter/material.dart';
import 'package:proj1/utils/Formaters.dart';

import '../../models/order.dart';

class OrderRecapScreen extends StatelessWidget {
  const OrderRecapScreen({Key? key, this.order}) : super(key: key);

  final Order? order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Success !!!"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Flexible(child: Text("Commande créée avec succes")),
            const Flexible(child: Icon(Icons.check_circle, color: Colors.green,size: 100, )),
            Flexible(child: Text("client : ${order?.customer.name}")),
            Flexible(child: Text("Total à payer : ${Formater.spaceSeparateNumbers("${order?.totalCost}")} DH")),
            order!.totalDiscount > 0 ? Flexible(child: Text("Total réduit : ${Formater.spaceSeparateNumbers("${order!.totalDiscount}")} DH")) : const SizedBox(height: 0,),
            const  Flexible(child: Text("La commande sera livrée une fois confirmée.")),
          ],
        ),
      ),
    );
  }
}
