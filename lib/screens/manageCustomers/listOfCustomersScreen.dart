import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/screens/manageCustomers/addCustomerScreen.dart';
import 'package:proj1/widgets/customerList.dart';

import '../../models/customer.dart';

class ListOfCustomersScreen extends ConsumerStatefulWidget {
  const ListOfCustomersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListOfCustomersScreen> createState() => _ListOfCustomersScreenState();
}

class _ListOfCustomersScreenState extends ConsumerState<ListOfCustomersScreen> {

  List<Customer> listCustomers = [];
  bool isLoading = false;
  bool failed = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    try{
      ref.read(listOfCustomersProvider.notifier).initListFromDb();
    } catch(e){
       setState(() {
         isLoading = false;
         failed = true;
       });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    listCustomers = ref.watch(listOfCustomersProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AddCustomerScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child : Icon(
                size: 35,
                Icons.add,  // add custom icons also
              ),
            ),
          ),
        ],
        title: const Text("Liste des clients"),
      ),
      body: isLoading ? const CircularProgressIndicator():
      listCustomers.isEmpty ? const Center(child : Text("Aucun client")) :
      ListView.builder(
        itemCount: listCustomers.length,
        itemBuilder: (context, index) {
          return CustomerList(
            customer: listCustomers[index],
            showDeleteButton: true,
            onDelete: () => ref.read(listOfCustomersProvider.notifier).deleteCustomer(listCustomers[index]),
            onClick: null,
          );
        },
      ),
    );
  }
}
