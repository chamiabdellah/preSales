import 'package:flutter/material.dart';

class EmptyListInfo extends StatelessWidget {
  const EmptyListInfo({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}
