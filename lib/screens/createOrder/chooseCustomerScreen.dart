import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../widgets/customerList.dart';

class ChooseCustomerScreen extends StatefulWidget {
  const ChooseCustomerScreen({Key? key}) : super(key: key);

  @override
  State<ChooseCustomerScreen> createState() => _ChooseCustomerScreenState();
}

class _ChooseCustomerScreenState extends State<ChooseCustomerScreen> {

  final List<Customer> nearCustomers = [];

  @override
  void initState() {
    super.initState();

  }

  void getNearCustomers() async {

    // 1 get current location

    // 2 get the near customers from the list

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des clients"),
      ),
      body: ListView.builder(
        itemCount: nearCustomers.length,
        itemBuilder: (context, index) {
          return CustomerList(customer: nearCustomers[index]);
        },
      ),
    );
  }
}
