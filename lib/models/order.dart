
import 'package:proj1/models/customer.dart';
import 'package:proj1/models/order_line.dart';

class Order{

  String? id;
  final Customer customer;
  List<OrderLine> listOrderLines;
  double totalCost;
  double totalDiscount;
  DateTime? creationDate;
  DateTime? confirmationDate;
  DateTime? deliveryDate;
  String? deliveryComment;
  String? orderNumber;

  Order.copy({
    required this.id,
    required this.customer,
    required this.listOrderLines,
    required this.totalCost,
    required this.totalDiscount,
    required this.creationDate,
    required this.confirmationDate,
    required this.deliveryComment,
    required this.deliveryDate,
    required this.orderNumber,
});

  Order({
    required this.customer,
    required this.listOrderLines,
    this.totalCost = 0,
    this.totalDiscount = 0,
  });

  double calculateTotalCost(){
    double orderSum = 0;
    for (var orderLine in listOrderLines) {
      orderSum += orderLine.calculateLineCost();
    }
    totalCost = orderSum;
    return orderSum;
  }

  double calculateTotalDiscounts(){
    double discountsSum = 0;
    for(OrderLine orderLine in listOrderLines){
      discountsSum += (orderLine.article.price - orderLine.discount) * orderLine.quantity;
    }
    totalDiscount = discountsSum;
    return totalDiscount;
  }

  Order.fromJson(MapEntry<String, dynamic> json):
      id = json.key,
      creationDate = DateTime.tryParse(json.value['creationDate'] ?? ""),
      customer = Customer.fromJson(MapEntry("", (json.value['customer'] as Map<String, dynamic>))),
      listOrderLines = json.value['listOrderLines'].map((orderLine) => OrderLine.fromJson(MapEntry("", (orderLine as Map<String, dynamic>)))).toList().cast<OrderLine>(),
      totalCost = json.value['totalCost'],
      totalDiscount = json.value['totalDiscount'],
      confirmationDate = DateTime.tryParse(json.value['confirmationDate']??""),
      deliveryDate = DateTime.tryParse(json.value['deliveryDate'] ?? ""),
      deliveryComment = json.value['deliveryComment'],
      orderNumber = json.value['orderNumber'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'totalCost' : totalCost,
    'totalDiscount' : totalDiscount,
    'customer' : customer.toJson(),
    'creationDate' : creationDate.toString(),
    'listOrderLines' : listOrderLines.map((orderLine) => orderLine.toJson()).toList(),
    'confirmationDate' : confirmationDate.toString(),
    'deliveryDate' : deliveryDate.toString(),
    'deliveryComment' : deliveryComment,
    'orderNumber' : orderNumber,
  };

  Order copyWith({
    String? id,
    Customer? customer,
    List<OrderLine>? listOrderLines,
    double? totalCost,
    double? totalDiscount,
    DateTime? creationDate,
    DateTime? confirmationDate,
    DateTime? deliveryDate,
    String? deliveryComment,
    String? orderNumber,
    }) => Order.copy(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      listOrderLines: listOrderLines ?? this.listOrderLines,
      totalCost: totalCost ?? this.totalCost,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      creationDate: creationDate ?? this.creationDate,
      confirmationDate: confirmationDate ?? this.confirmationDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryComment: this.deliveryComment,
      orderNumber: this.orderNumber,
  );
}