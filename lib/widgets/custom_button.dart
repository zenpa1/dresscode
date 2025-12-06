// lib/widgets/custom_button.dart (MODIFIED)

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function(BuildContext context) onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor; // Nullable for primary buttons

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    // Provide default values if not explicitly passed
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the border color. Use backgroundColor if no explicit border is given.
    final resolvedBorderColor = borderColor ?? backgroundColor;

    return SizedBox(
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          // Set the background fill color
          backgroundColor: backgroundColor,
          // Set the text color and font size
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                textColor, // This will be ignored by OutlinedButton, handle via foregroundColor
          ),
          // Set text and icon color
          foregroundColor: textColor,
          // Set the border
          side: BorderSide(color: resolvedBorderColor, width: 2),
          // Set the shape and rounding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          // Add padding
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        onPressed: () => onPressed(context),
        child: Text(text),
      ),
    );
  }
}
