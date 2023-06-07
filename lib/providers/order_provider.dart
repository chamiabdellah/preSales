import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/models/customer.dart';
import 'package:proj1/models/order.dart';
import 'package:proj1/models/order_line.dart';
import 'package:proj1/utils/Paths.dart';

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
    state!.listOrderLines.remove(orderLine);
  }

  void setQuantityOrderLine(OrderLine orderLine, double newQuatity){
    state!.listOrderLines.firstWhere((element) => element.index == orderLine.index).quantity = newQuatity;
  }

  void submitOrder() async {
    final Order? order = state;
    String link = PathsBuilder(Element.order).getElementPath();
    Uri uri = Uri.parse(link);

  }

}

final orderProvider = StateNotifierProvider<OrderNotifier, Order?>((ref){
  return OrderNotifier();
});