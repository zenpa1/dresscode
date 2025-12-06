// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  // Change the onPressed signature to accept a BuildContext, making it more flexible
  final void Function(BuildContext context)? onPressed;

  const CustomButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Call the onPressed function and pass the local context
      onPressed: () {
        if (onPressed != null) {
          onPressed!(context);
        } else {
          // Default action if no onPressed is provided
          debugPrint('$text button pressed');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      child: Text(text),
    );
  }
}
