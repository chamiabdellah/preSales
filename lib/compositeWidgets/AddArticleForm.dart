import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj1/utils/ValidationLib.dart';
import 'package:proj1/widgets/OutlineTextField.dart';
import 'package:http/http.dart' as http;

import '../utils/Paths.dart';

class AddArticleForm extends StatefulWidget {
  const AddArticleForm({Key? key}) : super(key: key);

  @override
  State<AddArticleForm> createState() => _AddArticleFormState();
}

class _AddArticleFormState extends State<AddArticleForm> {
  final _productFormKey = GlobalKey<FormState>();

  TextEditingController? articleNameController = TextEditingController();
  TextEditingController? articleQuantityController = TextEditingController();
  TextEditingController? articlePriceController = TextEditingController();
  TextEditingController? articleCodeController = TextEditingController();
  TextEditingController? articleUnitController = TextEditingController();
  TextEditingController? articleImageController = TextEditingController();

  bool? isNewCode = false;

  void addToDataBase() async {
    if(_productFormKey.currentState == null){
      return;
    }

    // 1- validate the fields.
    if(_productFormKey.currentState!.validate()){
      final String _articleCode = articleCodeController!.value.text;
      final isNewCodeI = await ValidationLib.isNewArticleCode(_articleCode);
      setState(() {
        isNewCode = isNewCodeI;
      });

      if(!isNewCode!){
        return;
      }
      final url = Uri.parse(Paths.articlePath);
      // 2- read the values from the fields => will be done using the controllers
      Map<String,dynamic> requestBody = {
        'articleCode' : _articleCode,
        'articleName' : articleNameController!.value.text,
        'image' : articleImageController!.value.text,
        'price' : double.parse(articlePriceController!.value.text),
        'quantity' : double.parse(articleQuantityController!.value.text),
        'unit' : articleUnitController!.value.text,
      };

      // 3 - send the request to the db
      final response = await http.post(url, body: json.encode(requestBody) );

      // 4 - get the save status :
      if(response.statusCode == 200){

      }
    }
    // 4 - treat the exceptions.
      // 4.1 - the product exists already in the db => add the condition to the validation of the code
      // 4.2 - the quantity is negative [DONE]
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _productFormKey,
      child: Column(
        children: [
          OutlineTextField(
            labelText: 'Nom de l\'article',
            validationFunc: ValidationLib.nonEmptyField,
            controller: articleNameController,
          ),
          OutlineTextField(
            labelText: 'Lien de l\'image',
            validationFunc: ValidationLib.nonEmptyField,
            controller: articleImageController,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: OutlineTextField(
                  labelText: 'Quantité disponible',
                  validationFunc: ValidationLib.isPositiveNumber,
                  textInputType: TextInputType.number,
                  controller: articleQuantityController,
                ),
              ),
              Flexible(
                flex: 1,
                child: OutlineTextField(
                  labelText: 'Unité',
                  validationFunc: ValidationLib.nonEmptyField,
                  controller: articleUnitController,
                ),
              ),
            ],
          ),
          OutlineTextField(
            labelText: 'code article',
            validationFunc: ValidationLib.nonEmptyField,
            controller: articleCodeController,
          ),
          Builder(builder: (BuildContext context){
            if(!isNewCode!){
              return Text("Ce code est déjà utilisé");
            }
            return const SizedBox.shrink();
          }),
          OutlineTextField(
            labelText: 'Prix',
            validationFunc: ValidationLib.isPositiveNumber,
            textInputType: TextInputType.number,
            controller: articlePriceController,
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: addToDataBase,
                  child: const Text(
                    "Ajouter",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
