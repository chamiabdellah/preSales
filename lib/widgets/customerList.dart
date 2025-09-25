import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer.dart';

class CustomerList extends ConsumerWidget {
  const CustomerList({Key? key,
    required this.customer,
    this.showDeleteButton = true,
    this.onDelete,
    this.onClick,}) : super(key: key);

  final Customer customer;
  final bool showDeleteButton;
  final VoidCallback? onDelete;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 80,
      child: Card(
        elevation: 5,
        child: ListTile(
          key: ValueKey(customer.id),
          leading: SizedBox(
            width: 60,
            height: 60,
            child: customer.picture != null && customer.picture!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      customer.picture!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person, size: 30),
                        );
                      },
                    ),
                  )
                : const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
          ),
          title: Text(customer.name),
          subtitle: Text(customer.address),
          trailing: showDeleteButton ? InkWell(
            onTap: onDelete,
            child: const Icon(
              size: 30,
              Icons.delete,
              color: Colors.deepOrangeAccent,
            ),
          ) : null,
          onTap: onClick,
        ),
      ),
    );
  }
}
