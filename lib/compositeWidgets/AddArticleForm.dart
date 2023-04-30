
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddArticleForm extends StatefulWidget {
  const AddArticleForm({Key? key}) : super(key: key);

  @override
  State<AddArticleForm> createState() => _AddArticleFormState();
}

class _AddArticleFormState extends State<AddArticleForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(),
        const TextField(),
      ],
    );
  }
}
