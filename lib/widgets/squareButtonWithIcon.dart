
import 'package:flutter/material.dart';

class Squarebuttonwithicon extends StatelessWidget {
  final double size;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const Squarebuttonwithicon({
    Key? key,
    required this.size,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 85),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
  

}
