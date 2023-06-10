
import 'package:proj1/models/customer.dart';
import 'package:proj1/models/order_line.dart';

class Order{

  String? id;
  DateTime? creationDate;
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
    double orderSum = 0;
    for (var orderLine in listOrderLines) {
      orderSum += orderLine.quantity * (orderLine.article.price - orderLine.discount);
    }
    totalCost = orderSum;
    return orderSum;
  }

  Order.fromJson(MapEntry<String, dynamic> json):
      id = json.key,
      creationDate = DateTime.parse(json.value['creationDate']),
      customer = Customer.fromJson(json.value['customer']),
      listOrderLines = json.value['listOrderLines'].map((orderLine) => OrderLine.fromJson(orderLine)).toList(),
      totalCost = json.value['totalCost'],
      totalDiscount = json.value['totalDiscount'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'totalCost' : totalCost,
    'totalDiscount' : totalDiscount,
    'customer' : customer.toJson(),
    'creationDate' : creationDate.toString(),
    'listOrderLines' : listOrderLines.map((orderLine) => orderLine.toJson()).toList(),
  };
}