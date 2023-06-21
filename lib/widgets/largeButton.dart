import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  const LargeButton({Key? key, required this.label, this.color, this.onClick}) : super(key: key);

  final void Function()? onClick;
  final Color? color;
  final String label;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      height: 70,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(color)),
        onPressed: onClick,
        child:  Text(label,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
