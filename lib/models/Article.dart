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

  Article.fromJson(MapEntry<String, dynamic> json):
    id = json.key,
    articleCode = json.value['articleCode'],
    unit = json.value['unit'],
    quantity = json.value['quantity'].toDouble(),
    price = json.value['price'].toDouble(),
    name = json.value['articleName'],
    picture = json.value['image'];

  Map<String,String> toJson() => {
    'articleCode': articleCode,
    'unit': unit,
    'quantity' : quantity.toString(),
    'price' : price.toString(),
    'name' : name,
    'picture' : picture,
  };

}