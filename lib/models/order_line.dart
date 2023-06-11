import 'package:proj1/models/Article.dart';

class OrderLine {

  final Article article;
  final String index;
  double quantity = 0;
  double discount = 0;
  double totalPrice = 0;
  double? availableQuantity;

  OrderLine({
    required this.article,
    required this.index,
    this.quantity = 0,
    this.discount = 0,
    this.totalPrice = 0,
});

  double calculateLineCost(){
    double lineCost = (article.price - discount) * quantity ;
    totalPrice = lineCost;
    return lineCost;
  }

  OrderLine.fromJson(MapEntry<String, dynamic> json):
        //article = Article.fromJson(MapEntry((json.value['article'] as Map<String, dynamic>)['id'],(json.value['article'] as Map<String, dynamic>))),
        article = Article.fromJson(MapEntry("",(json.value['article'] as Map<String, dynamic>))),
        index = json.value['index'],
        quantity = json.value['quantity'].toDouble(),
        discount = json.value['discount'].toDouble(),
        totalPrice = json.value['totalPrice'].toDouble(),
        availableQuantity = json.value['availableQuantity']?.toDouble();

  Map toJson() =>{
    'article' : article.toJson(),
    'index' : index,
    'quantity' : quantity,
    'discount' : discount,
    'totalPrice' : totalPrice,
    'availableQuantity' : availableQuantity,
  };

}