import 'package:proj1/models/Article.dart';

class OrderLine {

  final Article article;
  final String index;
  double quantity = 0;
  double discount = 0;
  double totalPrice = 0;

  OrderLine({
    required this.article,
    required this.index,
    this.quantity = 0,
    this.discount = 0,
    this.totalPrice = 0,
});

}