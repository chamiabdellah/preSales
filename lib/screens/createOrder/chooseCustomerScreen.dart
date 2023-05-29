import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/providers/order_provider.dart';
import 'package:proj1/screens/createOrder/scanArticleScreen.dart';
import 'package:proj1/utils/GeoUtils.dart';

import '../../models/customer.dart';
import '../../widgets/customerList.dart';

class ChooseCustomerScreen extends ConsumerStatefulWidget {
  const ChooseCustomerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChooseCustomerScreen> createState() => _ChooseCustomerScreenState();
}

class _ChooseCustomerScreenState extends ConsumerState<ChooseCustomerScreen> {

  List<Customer> nearCustomers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getNearCustomers();
  }

  void getNearCustomers() async {
    Position position = await GeoUtil.getUserLocation(context);
    final List<Customer> listCustomers = ref.read(listOfCustomersProvider);
    if(listCustomers.isEmpty){
      await ref.read(listOfCustomersProvider.notifier).initListFromDb();
    }

    setState(() {
      nearCustomers = ref.read(listOfCustomersProvider.notifier).findNearCustomers(position, 20);
      isLoading = false;
    });
  }

  void onSelectedCustomer(Customer customer){
    ref.read(orderProvider.notifier).createOrder(customer);

    // navigate to the next screen after choosing the customer
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ScanArticleScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisissez le client"),
      ),
      body: ListView.builder(
        itemCount: nearCustomers.length,
        itemBuilder: (context, index) {
          return CustomerList(
            customer: nearCustomers[index],
            showDeleteButton: false,
            onClick: () => onSelectedCustomer(nearCustomers[index]),
          );
        },
      ),
    );
  }
}
