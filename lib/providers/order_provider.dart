import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/models/order.dart';
import 'package:proj1/models/order_line.dart';
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

  void saveOrder() async {
    String link = PathsBuilder(Element.order).getElementPath();
    Uri uri = Uri.parse(link);
    Map<String, dynamic> requestBody = state!.toJson();
    final response = await http.post(uri, body: json.encode(requestBody));
    if(response.statusCode == 200){
      // clear the content of the order
      state = null;
    } else{
      throw Exception("Impossible d'enregistrer la commande.");
    }
  }

}

final orderProvider = StateNotifierProvider<OrderNotifier, Order?>((ref){
  return OrderNotifier();
});