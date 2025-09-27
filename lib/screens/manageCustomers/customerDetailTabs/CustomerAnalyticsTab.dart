import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/providers/filtered_orders_provider.dart';
import 'package:proj1/widgets/confirmOrders/orderList.dart';
import 'package:proj1/widgets/emptyListInfo.dart';

class CustomerAnalyticsTab extends ConsumerStatefulWidget {
  final Customer customer;

  const CustomerAnalyticsTab({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  ConsumerState<CustomerAnalyticsTab> createState() => _CustomerAnalyticsTabState();
}

class _CustomerAnalyticsTabState extends ConsumerState<CustomerAnalyticsTab> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomerOrders();
  }

  void _loadCustomerOrders() async {
    if (widget.customer.id == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      await ref.read(filteredOrdersProvider.notifier).fetchOrderByCustomer(widget.customer.id!);
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
    final orders = ref.watch(filteredOrdersProvider);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return const EmptyListInfo(message: "Aucune commande trouvée");
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderList(order: orders[index]);
      },
    );
  }
}