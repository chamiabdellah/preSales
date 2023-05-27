import 'package:proj1/models/Article.dart';

class OrderLine {

  final Article article;
  double quantity = 0;
  double discount = 0;
  double totalPrice = 0;

  OrderLine({
    required this.article,
    this.quantity = 0,
    this.discount = 0,
    this.totalPrice = 0,
});

}