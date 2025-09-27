import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/screens/manageCustomers/addCustomerScreen.dart';
import 'package:proj1/screens/manageCustomers/customerDetailTabs/CustomerDetailsTab.dart';
import 'package:proj1/screens/manageCustomers/customerDetailTabs/CustomerAnalyticsTab.dart';

class CustomerDetailsScreen extends ConsumerStatefulWidget {
  const CustomerDetailsScreen({Key? key, required this.customer}) : super(key: key);

  final Customer customer;

  @override
  ConsumerState<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends ConsumerState<CustomerDetailsScreen> with SingleTickerProviderStateMixin {
  late Customer currentCustomer;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    currentCustomer = widget.customer;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentCustomer.name),
        actions: [
          if (_tabController.index == 0)
            IconButton(
              onPressed: () async {
                final updatedCustomer = await Navigator.push<Customer>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCustomerScreen(editCustomer: currentCustomer),
                  ),
                );
                if (updatedCustomer != null) {
                  setState(() {
                    currentCustomer = updatedCustomer;
                  });
                }
              },
              icon: const Icon(Icons.edit),
            ),
          if (_tabController.index == 1)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bar_chart),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info, size: 16),
                SizedBox(width: 8),
                Text("Détails"),
              ],
            )),
            Tab(child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.analytics, size: 16),
                SizedBox(width: 8),
                Text("Commandes"),
              ],
            )),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CustomerDetailsTab(customer: currentCustomer),
          CustomerAnalyticsTab(customer: currentCustomer),
        ],
      ),

    );
  }
}