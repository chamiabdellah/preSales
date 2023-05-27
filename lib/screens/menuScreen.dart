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
          ),
          MenuItem(
            title : "Gérer les Clients",
            toScreen : ListOfCustomersScreen(),
            color : Colors.lime,
          ),
          MenuItem(
            title : "Créer une commande",
            toScreen : ChooseCustomerScreen(),
            color : Colors.greenAccent,
          ),
          MenuItem(
            title : "Confirmer une commande",
            toScreen : ListOfArticles(),
            color : Colors.redAccent,
          ),
          MenuItem(
            title : "Livrer une commande",
            toScreen : ListOfArticles(),
            color : Colors.black26,
          ),
        ],
      ),
    );
  }
}
