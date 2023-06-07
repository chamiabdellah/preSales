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

  OrderLine.fromJson(MapEntry<String, dynamic> json):
        article = Article.fromJson(json.value['name']),
        index = json.value['index'],
        quantity = json.value['quantity'].toDouble(),
        discount = json.value['discount'].toDouble(),
        totalPrice = json.value['totalPrice'].toDouble();

  Map toJson() =>{
    'article' : article.toJson(),
    'index' : index,
    'quantity' : quantity,
    'discount' : discount,
    'totalPrice' : totalPrice,
  };

}