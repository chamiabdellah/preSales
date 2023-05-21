

import 'package:flutter/material.dart';

class OutlineTextField extends StatefulWidget {
  const OutlineTextField({Key? key,
    required this.labelText,
    required this.validationFunc,
    this.textInputType = TextInputType.text,
    this.controller,
    this.onSaved,
    this.isEnabled = true}) : super(key: key);


  final String labelText;
  final String? Function(String?)? validationFunc;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final bool isEnabled;


  @override
  State<OutlineTextField> createState() => _OutlineTextFieldState();
}

class _OutlineTextFieldState extends State<OutlineTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const UnderlineInputBorder(),
        enabled: widget.isEnabled,
      ),
      validator: widget.validationFunc,
      controller: widget.controller,
      onSaved: widget.onSaved,
    );
  }
}

