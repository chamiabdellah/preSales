import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/providers/order_provider.dart';
import 'package:proj1/utils/DialogMessagesLib.dart';
import 'package:proj1/widgets/menuItem.dart';

import '../screens/createOrder/confirmOrderScreen.dart';
import '../screens/createOrder/searchCustomerScreen.dart';

class MutableMenuItem extends ConsumerStatefulWidget {
  const MutableMenuItem({Key? key}) : super(key: key);

  @override
  ConsumerState<MutableMenuItem> createState() => _MutableMenuItemState();
}

class _MutableMenuItemState extends ConsumerState<MutableMenuItem> {
  void onClick(BuildContext context) {
    final numberOfLines = ref.read(orderProvider)?.listOrderLines.length ?? 0;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => numberOfLines == 0
                ? const SearchCustomerScreen()
                : const ConfirmOrderScreen()
        )
    );
    if(numberOfLines > 0) {
      DialogMessagesLib.showSimpleAlert(
        context,
        'Vous devez valider ou annuler la commande en cours avant de créer une nouvelle'
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberOfLines = ref.watch(orderProvider)?.listOrderLines.length ?? 0;

    return MenuItem(
      title: "Créer une commande",
      toScreen: () => onClick(context),
      color: numberOfLines == 0 ? Colors.greenAccent : Colors.orangeAccent,
      assetLogo: 'assets/images/order_delivery.png',
    );
  }
}