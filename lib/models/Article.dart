import 'dart:core';

class Article {
  String id;
  String name;
  double quantity;
  String picture;
  double price;
  String unit;
  String articleCode;

  Article({
    this.id = "",
    required this.name,
    this.quantity = 0.0,
    this.picture = "",
    this.price = 0.0,
    this.unit="Pce",
  required this.articleCode});

}