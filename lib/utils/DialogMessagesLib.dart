
import 'package:flutter/material.dart';
import 'package:proj1/screens/manageArticles/addArticleScreen.dart';

import '../models/Article.dart';

class DialogMessagesLib {

  static SimpleDialog requestToScanAnArticle = const SimpleDialog(
    title: Text("Scannez l'article à ajouter"),
  );

  static void showSimpleAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerte'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showNotFoundArticleMessage(
      BuildContext context,
      String message,
      String articleCode,
      Function? actionOnValidation,
      ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerte'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Ajouter Article'),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) =>
                 AddArticleScreen(baseArticle: Article(articleCode: articleCode, name: ''), shouldAddArticle: true,)
                )).then((value) => {
                  if((value == true || value == null) && actionOnValidation != null){
                    actionOnValidation()
                  }
                });
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if(actionOnValidation != null) {
                  actionOnValidation();
                }
              },
            ),
          ],
        );
      },
    );
  }

}