
import 'package:proj1/models/customer.dart';
import 'package:proj1/models/order_line.dart';

class Order{

  final Customer customer;
  List<OrderLine> listOrderLines;
  double totalCost;
  double totalDiscount;

  Order({
    required this.customer,
    required this.listOrderLines,
    this.totalCost = 0,
    this.totalDiscount = 0,
});

  double calculateTotalCost(){

    for (var orderLine in listOrderLines) {
      totalCost += orderLine.totalPrice;
    }

    return totalCost;
  }

}