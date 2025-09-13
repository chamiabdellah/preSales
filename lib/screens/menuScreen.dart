import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/screens/confirmOrders/listOfOrdersScreen.dart';
import 'package:proj1/screens/deliverOrder/listOfDeliverOrdersScreen.dart';
import 'package:proj1/screens/manageCustomers/listOfCustomersScreen.dart';
import 'package:proj1/screens/manageSellers/listOfSellersScreen.dart';
import 'package:proj1/providers/user_credentials_provider.dart';
import 'package:proj1/widgets/imageNetworkCached.dart';

import '../widgets/MutableMenuItem.dart';
import '../widgets/cartAppBar.dart';
import '../widgets/menuItem.dart';
import 'manageArticles/listOfArticlesScreen.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userCredentialsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          if (currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 18,
                child: (currentUser.profilePic != null && currentUser.profilePic!.isNotEmpty)
                    ? ClipOval(
                        child: ImageNetworkCached(
                          imageUrl: currentUser.profilePic!,
                        ),
                      )
                    : const Icon(Icons.person),
              ),
            ),
          const CartAppBar(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MenuItem(
              title : "Gérer les articles",
              toScreen : () => Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => const ListOfArticles())),
              color : Colors.lightBlueAccent,
              assetLogo: 'assets/images/product.png',
            ),
            MenuItem(
              title : "Gérer les Clients",
              toScreen :  () => Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => const ListOfCustomersScreen())),
              color : Colors.lime,
              assetLogo: 'assets/images/people.png',
            ),
            const MutableMenuItem(),
            MenuItem(
              title : "Confirmer une commande",
              toScreen: () => Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => const ListOfOrdersScreen())),
              color : Colors.redAccent,
              assetLogo: 'assets/images/checkout.png',
            ),
            MenuItem(
              title : "Livrer une commande",
              toScreen : () => Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => const ListOfDeliverOrdersScreen())),
              color : Colors.blueGrey,
              assetLogo: 'assets/images/shipped.png',
            ),
            MenuItem(
              title : "Gérer Vendeurs",
              toScreen :  () => Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => const ListOfSellersScreen())),
              color : Colors.orange,
              assetLogo: 'assets/images/people.png',
            ),
          ],
        ),
      ),
    );
  }
}
