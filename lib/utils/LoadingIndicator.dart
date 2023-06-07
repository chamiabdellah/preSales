import 'package:flutter/material.dart';

class LoadingIndicator {

  static void showLoadingIndicator(String text, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              backgroundColor: Colors.black87,
              content: CircularProgressIndicator(
              ),
            )
        );
      },
    );
  }

  static void hideLoadingIndicator(BuildContext context) {
    Navigator.of(context).pop();
  }

}