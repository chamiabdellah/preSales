import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/models/order.dart';
import 'package:proj1/models/order_line.dart';
import 'package:proj1/utils/Formaters.dart';
import 'package:proj1/utils/Paths.dart';
import 'package:http/http.dart' as http;

class OrderNotifier extends StateNotifier<Order?>{
  OrderNotifier() : super(null);

  void createOrder(Customer customer){
    state = Order(customer: customer, listOrderLines: []);
  }

  void addOrderLine({required Article article,required double quantity,required double discount}){
    final OrderLine orderLine = OrderLine(
        article: article,
        index: '${state!.listOrderLines.length+1}',
        quantity: quantity,
        discount: discount);

    state!.listOrderLines.add(orderLine);
    Order? order = Order(customer: state!.customer, listOrderLines: state!.listOrderLines);
    order.id = state!.id;
    order.totalDiscount =  state!.totalDiscount;
    order.totalCost = state!.totalCost;

    state = order;

  }

  void deleteOrderLine(OrderLine orderLine){
    state!.listOrderLines.remove(orderLine);
  }

  void setQuantityOrderLine({required OrderLine orderLine,required double newQuatity}){
    state!.listOrderLines.firstWhere((element) => element.index == orderLine.index).quantity = newQuatity;
  }

  int? getOrderLinesLength(){
    return state?.listOrderLines.length;
  }
  
  Future<String> incrementOrderCounter() async {
    // 1 get the value of the counter from the database
    Uri uri = Uri.parse(PathsBuilder(Element.orderCounter).getElementPath());
    final getResponse = await http.get(uri);
    final getData = json.decode(getResponse.body) as Map<String, dynamic>;
    int counter = getData['OrderCounter'];

    // 2 increment and post the new value
    final requestBody = {'OrderCounter' :  counter + 1};
    final patchResponse = await http.patch(uri,body: requestBody);
    if(patchResponse.statusCode == 200){
      return counter.formatOrderCounter();
    } else {
      throw Exception("Erreur lors de l'incrémentation du compteur de la commande");
    }
  }

  void saveOrder() async {
    String link = PathsBuilder(Element.order).getElementPath();
    Uri uri = Uri.parse(link);
    state!.creationDate = DateTime.now();
    state!.orderNumber = await incrementOrderCounter();
    Map<String, dynamic> requestBody = state!.toJson();
    final response = await http.post(uri, body: json.encode(requestBody));
    if(response.statusCode == 200){
      state = null;
    } else{
      throw Exception("Impossible d'enregistrer la commande.");
    }
  }

}

final orderProvider = StateNotifierProvider<OrderNotifier, Order?>((ref){
  return OrderNotifier();
});