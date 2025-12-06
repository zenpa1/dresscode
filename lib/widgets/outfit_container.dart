import 'package:flutter/material.dart';
import 'outfit_clothing_card.dart';

class OutfitContainer extends StatelessWidget {
  final String outfitName;
  final List<String> clothingItems;

  const OutfitContainer({
    super.key,
    required this.outfitName,
    required this.clothingItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Small Text Label (Outfit Name)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
            child: Text(
              outfitName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),

          // Horizontal Row of Clothing Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: clothingItems
                  .map((name) => OutfitClothingCard(clothingName: name))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
