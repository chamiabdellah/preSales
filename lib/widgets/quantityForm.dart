

import 'package:flutter/material.dart';
import 'package:proj1/models/Article.dart';

import '../utils/Formaters.dart';
import '../utils/ValidationLib.dart';

class QuantityForm extends StatefulWidget {
  const QuantityForm({Key? key,
    required this.article,
    required this.setQuantity,
    required this.initQuantity}) : super(key: key);

  final Article article;
  final Function(double)? setQuantity;
  final double initQuantity;

  @override
  State<QuantityForm> createState() => _QuantityFormState();
}

class _QuantityFormState extends State<QuantityForm> {
  final _productFormKey = GlobalKey<FormState>();
  TextEditingController? articleQuantityController = TextEditingController();
  double chosenQuantity = 0;

  @override
  void initState() {
    super.initState();
    articleQuantityController!.text = widget.initQuantity.toString();
    chosenQuantity = widget.initQuantity;
  }

  @override
  void dispose() {
    super.dispose();
    articleQuantityController!.dispose();
  }

  void decrementQuantity(){
    if(chosenQuantity > 0) {
      articleQuantityController!.text = (chosenQuantity - 1).toString();

        chosenQuantity--;
        widget.setQuantity!(chosenQuantity);

    }
  }

  void incrementQuantity(){
    articleQuantityController!.text = (chosenQuantity+1).toString();

      chosenQuantity++;
      widget.setQuantity!(chosenQuantity);
  }

  void updatePrice(String? newQtty){
      chosenQuantity = double.parse(newQtty ?? "0");
      widget.setQuantity!(chosenQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Form(
            key: _productFormKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Quantité "),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: OutlinedButton(
                    //style: ButtonStyle(fixedSize: MaterialStateProperty.all(const Size(30, 50))),
                    onPressed: decrementQuantity,
                    child: const Text("-", style: TextStyle(fontSize: 25),),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20,),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    validator: ValidationLib.nonEmptyField,
                    controller: articleQuantityController,
                    onChanged: updatePrice,
                    onTap: () => articleQuantityController?.selection = TextSelection(baseOffset: 0, extentOffset: articleQuantityController!.value.text.length),
                    decoration: const InputDecoration(fillColor: Color.fromRGBO(
                        160, 177, 222, 0.4),
                    filled: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: OutlinedButton(
                    //style: ButtonStyle(fixedSize: MaterialStateProperty.all(const Size(30, 50))),
                    onPressed: incrementQuantity,
                    child: const Text("+", style: TextStyle(fontSize: 25),),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('${Formater.spaceSeparateNumbers('${widget.article.price * chosenQuantity}')} DH',
                    style: const TextStyle(fontSize: 25 , fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
