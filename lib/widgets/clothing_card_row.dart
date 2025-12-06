// lib/widgets/clothing_card_row.dart
import 'package:flutter/material.dart';
import 'clothing_card.dart';

class ClothingCardRow extends StatelessWidget {
  final PageController controller;
  final int itemsPerRow;
  final int virtualItemCount;
  final int initialPage;
  // 🚨 NEW PROPERTY: Callback function for card tap
  final VoidCallback? onCardTap;
  final double itemSize = 140.0;

  const ClothingCardRow({
    super.key,
    required this.controller,
    required this.itemsPerRow,
    required this.virtualItemCount,
    required this.initialPage,
    // 🚨 NEW: Include in constructor
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Reduced vertical padding
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: SizedBox(
        // Height adjusted based on item size and offset
        height: itemSize,
        child: PageView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          // Enables infinite looping
          itemCount: virtualItemCount,
          itemBuilder: (context, index) {
            return ClothingCard(
              index: index,
              controller: controller,
              itemSize: itemSize,
              itemsPerRow: itemsPerRow,
              initialPage: initialPage,
              // 🚨 MODIFIED: Pass the tap function down
              onCardTap: onCardTap,
            );
          },
        ),
      ),
    );
  }
}
