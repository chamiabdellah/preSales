import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/utils/Paths.dart';

import '../models/order.dart';


class ListOfConfirmOrdersNotifier extends StateNotifier<List<Order>>{
  ListOfConfirmOrdersNotifier() : super([]);

  Future<void> initOrdersListFromDb() async {
    //String link = PathsBuilder(Element.order).getElementPath();
    String link = Paths.unconfirmedOrders;
    Uri uri = Uri.parse(link);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Order> loadedItems = [];
      extractedData.forEach((key, value) {
        loadedItems.add(Order.fromJson(MapEntry(key, value)));
      });
      state = loadedItems;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> confirmOrder(Order newOrder) async{
    if(newOrder.id == null ) return;
    newOrder.confirmationDate = DateTime.now();
    newOrder.deliveryComment = "";
    String link = PathsBuilder(Element.order).getElementPathWithId(newOrder.id!);
    Uri uri = Uri.parse(link);
    Map<String, dynamic> requestBody = newOrder.toJson();
    final response = await http.patch(uri, body: json.encode(requestBody));
    if(response.statusCode != 200){
      throw Exception("Impossible de valider la commande.");
    }
    state = state.where((order) => order.id != newOrder.id).toList();
  }
}

final listOfConfirmOrdersProvider = StateNotifierProvider<ListOfConfirmOrdersNotifier, List<Order>>((ref){
  return ListOfConfirmOrdersNotifier();
});