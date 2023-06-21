import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/providers/order_provider.dart';
import 'package:proj1/screens/createOrder/confirmOrderScreen.dart';

import '../models/order.dart';

class CartAppBar extends ConsumerStatefulWidget {
  const CartAppBar({Key? key}) : super(key: key);

  @override
  ConsumerState<CartAppBar> createState() => _CartAppBarState();
}

class _CartAppBarState extends ConsumerState<CartAppBar> {

  void viewCartContent(){
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const ConfirmOrderScreen()));
  }

  @override
  Widget build(BuildContext context) {
    Order? order = ref.watch(orderProvider);
    int? numberOfLines;
    setState(() {
      numberOfLines = order?.listOrderLines.length;
    });

    return
      numberOfLines == null ?
      const SizedBox(width: 0,):
      InkWell(
      onTap: viewCartContent,
      child: Container(
        alignment: Alignment.center,
        width: 60,
        child: badges.Badge(
          position: badges.BadgePosition.topEnd(end: -5,top: -17),
          badgeContent: Text(numberOfLines?.toString() ?? "0", style: const TextStyle(fontSize: 20, color: Colors.white),),
          child: const Icon(
            Icons.shopping_cart_rounded,
            size: 35,
          ),
        ),
      ),
    );
  }
}
