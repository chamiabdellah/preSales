import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/screens/manageCustomers/addCustomerScreen.dart';

import '../models/customer.dart';

class CustomerList extends ConsumerWidget {
  const CustomerList({Key? key, required this.customer}) : super(key: key);

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 80,
      child: Card(
        elevation: 5,
        child: ListTile(
          key: ValueKey(customer.id),
          leading: const SizedBox(
            width: 100,
            child: Placeholder(),
          ),
          title: Text(customer.name),
          subtitle: Text(customer.address),
          trailing: InkWell(
            onTap: () => ref.read(listOfCustomersProvider.notifier).deleteCustomer(customer),
            child: const Icon(
              size: 30,
              Icons.delete,
              color: Colors.deepOrangeAccent,
            ),
          ),
          onTap: () {
            // Navigate to article 1
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const AddCustomerScreen()
              ),
            );
          },
        ),
      ),
    );
  }
}
