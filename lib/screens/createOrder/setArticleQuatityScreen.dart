import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/providers/order_provider.dart';
import 'package:proj1/screens/createOrder/confirmOrderScreen.dart';
import 'package:proj1/screens/createOrder/scanArticleScreen.dart';
import 'package:proj1/utils/ValidationLib.dart';
import 'package:proj1/widgets/articleList.dart';
import 'package:proj1/widgets/largeButton.dart';

import '../../widgets/cartAppBar.dart';
import '../manageArticles/addArticleScreen.dart';

class SetArticleQuantity extends ConsumerStatefulWidget {
  const SetArticleQuantity({Key? key,required this.article}) : super(key: key);

  final Article article;

  @override
  ConsumerState<SetArticleQuantity> createState() => _SetArticleQuantityState();
}

class _SetArticleQuantityState extends ConsumerState<SetArticleQuantity> {
  final _productFormKey = GlobalKey<FormState>();
  TextEditingController? articleQuantityController = TextEditingController();

  double chosenQuantity = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    articleQuantityController!.dispose();
  }

  void incrementQuantity(){
    articleQuantityController!.text = (chosenQuantity+1).toString();
    setState(() {
      chosenQuantity++;
    });
  }

  void decrementQuantity(){
    if(chosenQuantity > 0) {
      articleQuantityController!.text = (chosenQuantity - 1).toString();
      setState(() {
        chosenQuantity--;
      });
    }
  }

  void _createNewOrderLine(){
    ref.read(orderProvider.notifier).addOrderLine(article:  widget.article, quantity:  chosenQuantity, discount:  0);
  }

  void updatePrice(String? newQtty){
    setState(() {
      chosenQuantity = double.parse(newQtty ?? "0");
    });
  }

  void validateQuantity(){
    _createNewOrderLine();
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ConfirmOrderScreen()));
  }

  void addNewLine(){
    _createNewOrderLine();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const ScanArticleScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrez la quantité"),
        actions: const [
          CartAppBar(),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ArticleList(
                  article: widget.article,
                  onClick: ()=> Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => AddArticleScreen(baseArticle: widget.article)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text('Prix unitaire : ${widget.article.price} DH'),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: _productFormKey,
                  child: Row(
                    children: [
                      const Text("Quantité "),
                      TextButton(
                        onPressed: decrementQuantity,
                        child: const Text("-"),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: ValidationLib.nonEmptyField,
                          controller: articleQuantityController,
                          onChanged: updatePrice,
                          autofocus: true,
                        ),
                      ),
                      TextButton(
                        onPressed: incrementQuantity,
                        child: const Text("+"),
                      ),
                      Text(widget.article.unit),
                    ],
                  ),
                ),
                const SizedBox(height: 15,),
                Text('Total : ${widget.article.price * chosenQuantity} DH'),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                LargeButton(label: "Ajouter", color: Colors.greenAccent, action: addNewLine,),
                const SizedBox(height: 3),
                LargeButton(label: "Valider", color: Colors.pinkAccent, action: validateQuantity,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
