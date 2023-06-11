import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proj1/models/customer.dart';
import 'package:http/http.dart' as http;

import '../utils/Paths.dart';

class ListOfCustomersNotifier extends StateNotifier<List<Customer>> {
  ListOfCustomersNotifier() : super([]);

  void deleteCustomer(Customer customer) async {

    deleteCustomerUI(customer.id!);
    try{
      deleteCustomerDB(customer.id!);
    } catch(e){
      addCustomerUI(customer);
    }
  }

  void addCustomerUI(Customer customer){
    state = [...state, customer];
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      String customerId = await addCustomerToDB(customer);
      customer.id = customerId;
    } catch (e) {
      throw Exception('Impossible d\'ajouter le client ${customer.name}');
    }

    addCustomerUI(customer);
  }

  void deleteCustomerUI(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void modifyCustomer(Customer newCustomer, String id) {
    deleteCustomerUI(id);
    addCustomer(newCustomer);
  }

  Customer getCustomerByCode(String code) {
    return state.firstWhere((element) => element.code == code);
  }

  Future<void> initListFromDb() async {
    String link = Paths.customerPath;
    Uri uri = Uri.parse(link);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Customer> loadedItems = [];
      extractedData.forEach((key, value) {
        loadedItems.add(Customer(
          address: value['address'],
          code: value['code'],
          longitude: value['longitude'],
          latitude: value['latitude'],
          name: value['name'],
          id: key,
        ));
      });
      state = loadedItems;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> addCustomerToDB(Customer customer) async {
    String link = Paths.customerPath;
    Uri uri = Uri.parse(link);
    Map<String, dynamic> requestBody = {
      'name': customer.name,
      'address': customer.address,
      'longitude' : customer.longitude,
      'latitude' : customer.latitude,
      'code': '${customer.longitude};${customer.latitude}:${customer.name}',
    };
    final response = await http.post(uri, body: json.encode(requestBody));

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return extractedData['name'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  void deleteCustomerDB(String id) async {
    String link = Paths.getCustomerPathWithId(id);
    Uri uri = Uri.parse(link);
    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }
  }

  List<Customer> findNearCustomers(Position position, double distance){
    const int accuracy = 100;
    return state.where((customer) {
      return Geolocator.distanceBetween(position.latitude, position.longitude,
                                                    customer.latitude, customer.longitude) < distance + accuracy;
    }).toList();
  }
}

final listOfCustomersProvider = StateNotifierProvider<ListOfCustomersNotifier, List<Customer>>((ref){
  return ListOfCustomersNotifier();
});