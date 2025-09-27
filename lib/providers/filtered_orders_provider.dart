import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/utils/SecurePath.dart';
import '../utils/Paths.dart';

class FilteredOrdersNotifier extends StateNotifier<List<Order>> {
  FilteredOrdersNotifier() : super([]);

  Future<void> fetchOrdersBySeller(String sellerId) async {
    await _fetchOrdersByField('seller/id', sellerId);
  }

  Future<void> fetchOrderByCustomer(String customerId) async {
    await _fetchOrdersByField('customer/id', customerId);
  }

  Future<void> _fetchOrdersByField(String field, String value) async {
    try {
      String link = await SecurePath.appendToken('${PathsBuilder(Element.order).getElementPath()}?orderBy="$field"&equalTo="$value"');
      Uri uri = Uri.parse(link);
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as Map<String, dynamic>;
        final List<Order> loadedOrders = [];
        extractedData.forEach((key, value) {
          loadedOrders.add(Order.fromJson(MapEntry(key, value)));
        });
        state = loadedOrders;
      } else {
        throw Exception('Erreur lors du chargement des commandes');
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement des commandes: $e');
    }
  }

  void clearOrders() {
    state = [];
  }
}

final filteredOrdersProvider = StateNotifierProvider<FilteredOrdersNotifier, List<Order>>((ref) {
  return FilteredOrdersNotifier();
});