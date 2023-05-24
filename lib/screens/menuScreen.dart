import 'package:flutter/material.dart';

import '../widgets/menuItem.dart';
import 'listOfArticlesScreen.dart';

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
            toScreen : ListOfArticles(),
            color : Colors.lime,
          ),
          MenuItem(
            title : "Créer une commande",
            toScreen : ListOfArticles(),
            color : Colors.greenAccent,
          ),
          MenuItem(
            title : "Livrer une commande",
            toScreen : ListOfArticles(),
            color : Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
