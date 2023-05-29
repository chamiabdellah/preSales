import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/models/order.dart';
import 'package:proj1/models/order_line.dart';

class OrderNotifier extends StateNotifier<Order?>{
  OrderNotifier() : super(null);

  void createOrder(Customer customer){
    state = Order(customer: customer, listOrderLines: []);
  }

  void addOrderLine(Article article, double quantity, double discount){
    final OrderLine orderLine = OrderLine(
        article: article,
        index: '${state!.listOrderLines.length+1}',
        quantity: quantity,
        discount: discount);

    state!.listOrderLines.add(orderLine);
  }

  void deleteOrderLine(OrderLine orderLine){
    state!.listOrderLines = state!.listOrderLines.where(
            (ordLne) => ordLne.article.id != orderLine.article.id
                && ordLne.index != orderLine.index)
        .toList();
  }

}

final orderProvider = StateNotifierProvider<OrderNotifier, Order?>((ref){
  return OrderNotifier();
});