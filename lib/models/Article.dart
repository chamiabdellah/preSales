

import 'dart:core';
import 'dart:ffi';

class Article {
  String name;
  double quantity;
  String picture;
  double price;
  String unit;

  Article({required this.name, this.quantity = 0.0, this.picture = "", this.price = 0.0, this.unit="Pce"});

}