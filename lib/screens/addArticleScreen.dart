import 'package:flutter/material.dart';

import '../compositeWidgets/AddArticleForm.dart';

class AddArticleScreen extends StatelessWidget {
  const AddArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un article"),
      ),
      body: Column(
        children:  const [
          Flexible(
            child: AddArticleForm(),
          ),
        ],
      ),
    );
  }
}
