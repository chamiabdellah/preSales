import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proj1/providers/list_of_customers_provider.dart';
import 'package:proj1/providers/order_provider.dart';
import 'package:proj1/screens/createOrder/SearchOrScanArticle.dart';
import 'package:proj1/utils/GeoUtils.dart';
import 'package:proj1/widgets/emptyListInfo.dart';

import '../../models/customer.dart';
import '../../widgets/customerList.dart';

class SearchCustomerScreen extends ConsumerStatefulWidget {
  const SearchCustomerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchCustomerScreen> createState() => _SearchCustomerScreenState();
}

class _SearchCustomerScreenState extends ConsumerState<SearchCustomerScreen> {

  List<Customer> customersList = [];
  List<Customer> filteredCustomersList = [];
  bool isLoading = false;
  bool notFoundLocation = false;
  bool searchMode = false;

  @override
  void initState() {
    super.initState();
    getCustomers(searchMode);
  }

  void getCustomers(bool byLocation) async {
    setState(() {
      isLoading = true;
    });

    customersList = await ref.read(listOfCustomersProvider.notifier).getAllCustomers();
    
    if(byLocation && mounted){
      Position? position = await GeoUtil.getUserLocation(context);
      if(position == null){
        setState(() {
          isLoading = false;
          notFoundLocation = true;
        });
        return;
      }
      setState(() {
        customersList = ref.read(listOfCustomersProvider.notifier).findNearCustomers(position, 100);
        filteredCustomersList = customersList;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void onSelectedCustomer(Customer customer){
    ref.read(orderProvider.notifier).createOrder(customer);
    // navigate to the next screen after choosing the customer
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const SearchOrScanArticle()));
  }

  void filterCustomerByName(String name){
    final result = name.splitMapJoin(RegExp(r'\w?'), onMatch: (m)=> '\\s*${m[0]}', onNonMatch: (n) => '');
    setState(() {
      filteredCustomersList = customersList.where((customer) => RegExp(result, caseSensitive: false).hasMatch(customer.name)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisissez le client"),
        actions: [
          searchMode ? IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  searchMode = false;
                  getCustomers(searchMode);
                });
              },
          ) :
          IconButton(
              icon: const Icon(Icons.gps_fixed_sharp),
              onPressed: () {
                setState(() {
                  searchMode = true;
                  getCustomers(searchMode);
                  filterCustomerByName('');
                });
              },
          ),
        ],
      ),
      body: isLoading ? const Center(child:CircularProgressIndicator()) :
          notFoundLocation ? const EmptyListInfo(message: "Impossible de determiner votre emplacement!") :
          customersList.isEmpty ? const EmptyListInfo(message: "Aucun client trouvé...") :
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Visibility(
             visible: !searchMode,
              replacement: const Padding(
                padding:  EdgeInsets.all(10.0),
                child: Text("Clients proches", style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: "Chercher un client",
                  hintStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
                  textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 20)),
                  shape: const WidgetStatePropertyAll(ContinuousRectangleBorder()),
                  onChanged: (newValue){
                    filterCustomerByName(newValue);
                  },
                ),
              ),
          ),
          !searchMode ? Expanded(
            child: ListView.builder(
              itemCount: filteredCustomersList.length,
              itemBuilder: (context, index) {
                return CustomerList(
                  customer: filteredCustomersList[index],
                  showDeleteButton: false,
                  onClick: () => onSelectedCustomer(filteredCustomersList[index]),
                );
              },
            ),
          ) :
           Expanded(
            child: ListView.builder(
              itemCount: customersList.length,
              itemBuilder: (context, index) {
                return CustomerList(
                  customer: customersList[index],
                  showDeleteButton: false,
                  onClick: () => onSelectedCustomer(customersList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
