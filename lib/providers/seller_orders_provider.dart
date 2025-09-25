import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/utils/SecurePath.dart';
import '../utils/Paths.dart';

class SellerOrdersNotifier extends StateNotifier<List<Order>> {
  SellerOrdersNotifier() : super([]);

  Future<void> fetchOrdersBySeller(String sellerId) async {
    try {
      String link = await SecurePath.appendToken('${PathsBuilder(Element.order).getElementPath()}?orderBy="seller/id"&equalTo="$sellerId"');
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

final sellerOrdersProvider = StateNotifierProvider<SellerOrdersNotifier, List<Order>>((ref) {
  return SellerOrdersNotifier();
});