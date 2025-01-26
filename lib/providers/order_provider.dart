import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/models/order.dart';
import 'package:proj1/models/order_line.dart';
import 'package:proj1/utils/Formaters.dart';
import 'package:proj1/utils/Paths.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/utils/SecurePath.dart';

class OrderNotifier extends StateNotifier<Order?>{
  OrderNotifier() : super(null);

  void createOrder(Customer customer){
    state = Order(customer: customer, listOrderLines: []);
  }

  void addOrderLine({required Article article, required double quantity, required double discount}) {
    if (state == null) return;

    // Create a new list to store the updated order lines
    List<OrderLine> updatedOrderLines = List.of(state!.listOrderLines);

    // Check if the article already exists in order lines
    final existingLineIndex = updatedOrderLines.indexWhere(
            (line) => line.article.articleCode == article.articleCode
    );

    if (existingLineIndex != -1) {
      // Update existing order line
      OrderLine existingLine = updatedOrderLines[existingLineIndex];
      updatedOrderLines[existingLineIndex] = OrderLine(
          article: existingLine.article,
          index: existingLine.index,
          quantity: existingLine.quantity + quantity,
          discount: existingLine.discount
      );
    } else {
      // Add new order line
      final OrderLine orderLine = OrderLine(
          article: article,
          index: '${updatedOrderLines.length + 1}',
          quantity: quantity,
          discount: discount
      );
      updatedOrderLines.add(orderLine);
    }

    // Create a new Order with the updated list
    Order updatedOrder = Order(
        customer: state!.customer,
        listOrderLines: updatedOrderLines
    );
    updatedOrder.id = state!.id;
    updatedOrder.totalDiscount = state!.totalDiscount;
    updatedOrder.totalCost = state!.totalCost;

    // Update the state with the new order
    state = updatedOrder;
  }

  void deleteOrderLine(OrderLine orderLine){
    state!.listOrderLines.remove(orderLine);
    state = state?.copyWith();
  }

  void setQuantityOrderLine({required OrderLine orderLine,required double newQuatity}){
    state!.listOrderLines.firstWhere((element) => element.index == orderLine.index).quantity = newQuatity;
  }

  int? getOrderLinesLength(){
    return state?.listOrderLines.length;
  }
  
  Future<String> incrementOrderCounter() async {
    // 1 get the value of the counter from the database
    final securedPath = await SecurePath.appendToken(PathsBuilder(Element.orderCounter).getElementPath());
    Uri uri = Uri.parse(securedPath);
    final getResponse = await http.get(uri);
    final getData = json.decode(getResponse.body) as Map<String, dynamic>;
    int counter = getData['OrderCounter'];

    // 2 increment and post the new value
    final Map<String, int> requestBody = {'OrderCounter' :  counter + 1};
    final patchResponse = await http.patch(uri,body: json.encode(requestBody));
    if(patchResponse.statusCode == 200){
      return counter.formatOrderCounter();
    } else {
      throw Exception("Erreur lors de l'incrémentation du compteur de la commande");
    }
  }

  Future<void> saveOrder() async {
    String link = await SecurePath.appendToken(PathsBuilder(Element.order).getElementPath());
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

  void removeOrder() {
    state = null;
  }

}

final orderProvider = StateNotifierProvider<OrderNotifier, Order?>((ref){
  return OrderNotifier();
});