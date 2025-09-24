
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

  static void showInsufficientStockDialog(BuildContext context, String errorMessage) {
    final message = errorMessage.replaceFirst('Exception: ', '');
    final parts = message.split('\n\n');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stock insuffisant'),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              const TextSpan(text: 'Stock insuffisant pour l\'article:\n\n'),
              TextSpan(
                text: '${parts.length > 1 ? parts[1] : ''}\n\n',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextSpan(text: parts.length > 2 ? parts[2] : ''),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

}