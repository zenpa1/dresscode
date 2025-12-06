// lib/widgets/clothing_card.dart
import 'package:flutter/material.dart';

class ClothingCard extends StatelessWidget {
  // Required props for the transformation and display logic
  final int index;
  final PageController controller;
  final double itemSize;
  final int itemsPerRow;
  final int initialPage;

  const ClothingCard({
    super.key,
    required this.index,
    required this.controller,
    required this.itemSize,
    required this.itemsPerRow,
    required this.initialPage,
  });

  @override
  Widget build(BuildContext context) {
    double value = 0.0;

    double currentPage = controller.hasClients && controller.page != null
        ? controller.page!
        : initialPage.toDouble();

    // Calculate the distance from the center page
    value = currentPage - index;
    value = value.clamp(-1.0, 1.0);

    // Calculate the real item index for display/content
    final int realIndex = index % itemsPerRow;

    // --- Transformation Properties ---
    const double minScale = 0.35;
    const double maxVerticalOffset = 10.0;
    // 1. Scale: Larger in center (1.0), smaller on sides (minScale)
    final double scale = 1.0 - (value.abs() * (1.0 - minScale));
    // 2. Vertical Offset: Move item UP (negative Y) proportionally to distance from center
    final double offsetY = -value.abs() * maxVerticalOffset;

    return Center(
      child: Transform(
        // Apply both Translate (vertical offset) and Scale
        transform: Matrix4.identity()
          ..translate(0.0, offsetY)
          ..scale(scale, scale),

        alignment: FractionalOffset.center,
        child: Container(
          width: itemSize,
          height: itemSize,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              'Item ${realIndex + 1}',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
