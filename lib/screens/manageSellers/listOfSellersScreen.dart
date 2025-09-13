import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/providers/list_of_sellers_provider.dart';
import 'package:proj1/widgets/emptyListInfo.dart';
import 'package:proj1/models/User.dart';

import '../../widgets/imageNetworkCached.dart';

class ListOfSellersScreen extends ConsumerStatefulWidget {
  const ListOfSellersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListOfSellersScreen> createState() => _ListOfSellersScreenState();
}

class _ListOfSellersScreenState extends ConsumerState<ListOfSellersScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSellers();
  }

  void _loadSellers() async {
    try {
      await ref.read(listOfSellersProvider.notifier).fetchSellers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<User> sellers = ref.watch(listOfSellersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer Vendeurs'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sellers.isEmpty
              ? const EmptyListInfo(message: "Aucun vendeur trouvé")
              : ListView.builder(
                  itemCount: sellers.length,
                  itemBuilder: (context, index) {
                    final seller = sellers[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: seller.profilePic != null && seller.profilePic!.isNotEmpty
                              ? ImageNetworkCached(imageUrl: seller.profilePic!) : const Icon(Icons.person),
                        ),
                        title: Text(seller.name),
                        subtitle: Text(seller.email),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // TODO: Navigate to edit seller screen
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}