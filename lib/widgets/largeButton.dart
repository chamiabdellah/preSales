import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  const LargeButton({Key? key, required this.label, this.color, this.action}) : super(key: key);

  final void Function()? action;
  final Color? color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(color)),
        onPressed: action,
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
