import 'package:flutter/material.dart';
import 'package:proj1/screens/createOrder/chooseCustomerScreen.dart';
import 'package:proj1/screens/manageCustomers/listOfCustomersScreen.dart';

import '../widgets/menuItem.dart';
import 'manageArticles/listOfArticlesScreen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
      ),
      body: const Column(
        children: [
          MenuItem(
            title : "Gérer les articles",
            toScreen : ListOfArticles(),
            color : Colors.lightBlueAccent,
            assetLogo: 'assets/images/product.png',
          ),
          MenuItem(
            title : "Gérer les Clients",
            toScreen : ListOfCustomersScreen(),
            color : Colors.lime,
            assetLogo: 'assets/images/people.png',
          ),
          MenuItem(
            title : "Créer une commande",
            toScreen : ChooseCustomerScreen(),
            color : Colors.greenAccent,
            assetLogo: 'assets/images/order_delivery.png',
          ),
          MenuItem(
            title : "Confirmer une commande",
            toScreen : ListOfArticles(),
            color : Colors.redAccent,
            assetLogo: 'assets/images/checkout.png',
          ),
          MenuItem(
            title : "Livrer une commande",
            toScreen : ListOfArticles(),
            color : Colors.blueGrey,
            assetLogo: 'assets/images/shipped.png',
          ),
        ],
      ),
    );
  }
}
