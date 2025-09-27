import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/customer.dart';

class CustomerAnalyticsTab extends ConsumerWidget {
  final Customer customer;

  const CustomerAnalyticsTab({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text(
        "Commandes du client",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}