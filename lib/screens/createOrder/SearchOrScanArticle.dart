import 'package:flutter/material.dart';

import 'scanArticleScreen.dart';

class SearchOrScanArticle extends StatelessWidget {
  const SearchOrScanArticle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selectioner ou scanner un article"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const ScanArticleScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Scanner',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16), // Space between the two buttons
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Chercher',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}