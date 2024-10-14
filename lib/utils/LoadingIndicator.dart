import 'package:flutter/material.dart';

class LoadingIndicator {
  static void showLoadingIndicator(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              backgroundColor: Colors.black87,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 10,),
                  Text(
                    '$text...',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }

  static void hideLoadingIndicator(BuildContext context) {
    Navigator.of(context).pop();
  }
}
