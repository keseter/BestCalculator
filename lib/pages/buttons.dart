import "package:flutter/material.dart";

class CalculatorButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CalculatorButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.blue.withValues(red: 0, green: 0, blue: 5, alpha: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow),
      ),
    );
  }
}
