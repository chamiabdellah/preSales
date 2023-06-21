import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/screens/manageCustomers/addCustomerScreen.dart';
import 'package:proj1/widgets/customerList.dart';
import 'package:proj1/widgets/emptyListInfo.dart';

import '../../models/customer.dart';

class ListOfCustomersScreen extends ConsumerStatefulWidget {
  const ListOfCustomersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListOfCustomersScreen> createState() => _ListOfCustomersScreenState();
}

class _ListOfCustomersScreenState extends ConsumerState<ListOfCustomersScreen> {

  List<Customer> listCustomers = [];
  bool isLoading = true;
  bool failed = true;

  void fetchCustomers() async {
    setState(() {
      isLoading = true;
    });
    try{
      await ref.read(listOfCustomersProvider.notifier).initListFromDb();
      setState(() {
        isLoading = false;
      });
    } catch(e){
      setState(() {
        isLoading = false;
        failed = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomers();
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
      body: isLoading ? const Center(child:CircularProgressIndicator()) :
      listCustomers.isEmpty ? const EmptyListInfo( message: "Aucun client") :
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
