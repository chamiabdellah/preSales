

import 'dart:convert';

import 'package:proj1/models/unit.dart';
import 'package:proj1/utils/SecurePath.dart';

import 'Paths.dart';
import 'package:http/http.dart' as http;

class ValidationLib{

  static String? nonEmptyField(value) {
    if (value == null || value!.isEmpty) {
      return 'Ce champ est obligatoir';
    }
    return null;
  }

  static String? isValidUnit(Unit? unit){
    if (unit == null) {
      return 'Ce champ est obligatoir';
    }
    if(double.tryParse(unit.portion ?? '') == null){
      return 'Quantité Invalide';
    }
    return null;
  }

  static String? isPositiveNumber(String? value){

    if(value == null) {
      return 'Quantite invalide';
    }
    double? num = double.tryParse(value);
    if(num == null){
      return 'Quantite invalide';
    } else if(num < 0){
      return 'Entrez une valeur positive';
    }
    return null;
  }

  static Future<bool?> isNewArticleCode(String? articleCode) async {

    final securedPath = await SecurePath.appendToken(Paths.getArticleByCodePath(articleCode!, null));
    final url = Uri.parse(securedPath);
    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if(extractedData.isEmpty){
      return true;
    }
    return false;
  }

}