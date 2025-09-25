import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/User.dart';
import 'package:proj1/providers/seller_orders_provider.dart';
import 'package:proj1/widgets/confirmOrders/orderList.dart';
import 'package:proj1/widgets/emptyListInfo.dart';

class SellerOrdersScreen extends ConsumerStatefulWidget {
  final User seller;
  
  const SellerOrdersScreen({Key? key, required this.seller}) : super(key: key);

  @override
  ConsumerState<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends ConsumerState<SellerOrdersScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSellerOrders();
  }

  void _loadSellerOrders() async {
    try {
      await ref.read(sellerOrdersProvider.notifier).fetchOrdersBySeller(widget.seller.userId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
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
    final orders = ref.watch(sellerOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Commandes de ${widget.seller.name}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const EmptyListInfo(message: "Aucune commande trouvée")
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return OrderList(order: orders[index]);
                  },
                ),
    );
  }
}