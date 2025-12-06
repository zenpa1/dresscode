import 'package:flutter/material.dart';

class OutfitClothingCard extends StatelessWidget {
  final String clothingName;

  const OutfitClothingCard({super.key, required this.clothingName});

  final double itemSize = 90.0; // Smaller size for outfit display

  @override
  Widget build(BuildContext context) {
    return Container(
      width: itemSize,
      height: itemSize,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Center(
        child: Text(
          clothingName,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54, fontSize: 10),
        ),
      ),
    );
  }
}
