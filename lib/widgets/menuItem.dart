import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({Key? key, required this.title, required this.toScreen, this.color = Colors.lightBlue})
      : super(key: key);

  final String title;
  final Widget toScreen;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => toScreen));
      },
      child: Text(title),
    );
  }
}
