// lib/widgets/clothing_card_row.dart (Scaling fix using internal padding/margin)

import 'package:flutter/material.dart';
import 'package:dresscode/utils/app_constants.dart';
import 'dart:math';

class ClothingCardRow extends StatelessWidget {
  final PageController controller;
  final List<ClothingItem> categoryItems;
  final int virtualItemCount;
  final int initialPage;
  final VoidCallback? onCardTap;

  const ClothingCardRow({
    super.key,
    required this.controller,
    required this.categoryItems,
    required this.virtualItemCount,
    required this.initialPage,
    this.onCardTap,
  });

  // Function to calculate scaling based on center distance
  double getScale(int index) {
    if (!controller.hasClients || controller.page == null) return 0.5;

    final page = controller.page ?? initialPage.toDouble();
    final difference = (index - page).abs();

    return max(0.5, 1.0 - difference * 0.4);
  }

  @override
  Widget build(BuildContext context) {
    final itemsCount = categoryItems.length;
    final double itemSize = 140.0;

    return SizedBox(
      height: itemSize,
      child: PageView.builder(
        controller: controller,
        itemCount: virtualItemCount,
        itemBuilder: (context, index) {
          if (itemsCount == 0) return const SizedBox.shrink();

          final actualIndex = (index - initialPage) % itemsCount;
          final item = categoryItems[actualIndex];
          final scale = getScale(index);

          return Center(
            child: Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTap: onCardTap,
                child: Container(
                  width: itemSize,
                  height: itemSize,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 2.0,
                      color: const Color.fromARGB(255, 231, 227, 227),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(
                      8.0,
                    ), // MODIFY FOR SCALING PLEASE
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        item.imagePath,
                        fit: BoxFit
                            .contain, // Use .contain to see the whole image without cropping
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              'Error: ${item.name}',
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
