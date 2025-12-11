import 'package:flutter/material.dart';

class OutfitClothingCard extends StatelessWidget {
  final String label;
  final String? imagePath;
  final double itemSize;

  const OutfitClothingCard({
    super.key,
    required this.label,
    this.imagePath,
    this.itemSize = 90.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: itemSize,
      height: itemSize,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imagePath != null
            ? Image.asset(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _fallbackLabel();
                },
              )
            : _fallbackLabel(),
      ),
    );
  }

  Widget _fallbackLabel() {
    return Container(
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black54, fontSize: 10),
      ),
    );
  }
}
