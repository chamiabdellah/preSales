import 'package:flutter/material.dart';
import 'package:proj1/screens/createOrder/searchArticleScreen.dart';
import 'package:proj1/widgets/squareButtonWithIcon.dart';

import 'scanArticleScreen.dart';

class SearchOrScanArticle extends StatelessWidget {
  const SearchOrScanArticle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selectioner ou scanner un article"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double buttonSize = constraints.maxWidth / 2;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Squarebuttonwithicon(
                      size: buttonSize,
                      icon: Icons.search,
                      label: 'Chercher',
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SearchArticleScreen()))
                      },
                    ),
                    Squarebuttonwithicon(
                      size: buttonSize,
                      icon: Icons.barcode_reader, // Changed from barcode_reader
                      label: 'Scanner',
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ScanArticleScreen()))
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}