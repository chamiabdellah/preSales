import 'package:flutter/material.dart';

import '../utils/Formaters.dart';

class QuantityForm extends StatefulWidget {
  const QuantityForm({Key? key,
    required this.articlePrice,
    required this.setQuantity,
    this.initQuantity,
    this.autoFocus = false,
  }) : super(key: key);

  final double articlePrice;
  final Function(double)? setQuantity;
  final double? initQuantity;
  final bool autoFocus;

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
    chosenQuantity = widget.initQuantity ?? 0;
    if(widget.initQuantity != null) {
      articleQuantityController!.text = widget.initQuantity!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    articleQuantityController!.dispose();
  }

  void decrementQuantity(){
    if(chosenQuantity > 0) {
      articleQuantityController!.text = (chosenQuantity - 1).toStringAsFixed(0);

        chosenQuantity--;
        widget.setQuantity!(chosenQuantity);

    }
  }

  void incrementQuantity(){
    articleQuantityController!.text = (chosenQuantity+1).toStringAsFixed(0);

      chosenQuantity++;
      widget.setQuantity!(chosenQuantity);
  }

  void updatePrice(String? newQtty){
    double? quantityDouble = double.tryParse(newQtty ?? "0");
    if(quantityDouble != null && quantityDouble < 0 ){
      quantityDouble = 0;
    }
    chosenQuantity = quantityDouble ?? 0;
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
                    autofocus: widget.autoFocus,
                    style: const TextStyle(fontSize: 20,),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    controller: articleQuantityController,
                    onChanged: updatePrice,
                    onTap: () => articleQuantityController?.selection = TextSelection(baseOffset: 0, extentOffset: articleQuantityController!.value.text.length),
                    decoration: const InputDecoration(fillColor: Color.fromRGBO(
                        160, 177, 222, 0.2),
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
                    child: Text('${((widget.articlePrice * chosenQuantity).toMonetaryString())} DH',
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
