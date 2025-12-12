// lib/widgets/clothing_card_row.dart (Scaling fix using internal padding/margin)

import 'package:flutter/material.dart';
import 'package:dresscode/utils/app_constants.dart';
import 'dart:math';
import 'dart:io';

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

  /// Determines if the path is a file system path or asset path and builds the appropriate Image widget
  Widget _buildImage(ClothingItem item) {
    final imagePath = item.imagePath;

    if (imagePath.isEmpty) {
      return Center(child: Text(item.name, textAlign: TextAlign.center));
    }

    // Check if it's a file system path (absolute path) vs asset path
    final isFilePath =
        imagePath.startsWith('/') ||
        imagePath.contains(RegExp(r'^[A-Za-z]:\\')) || // Windows path
        imagePath.contains('/data/') ||
        imagePath.contains('app_flutter');

    if (isFilePath && File(imagePath).existsSync()) {
      // It's a file system path - use Image.file()
      return Image.file(
        File(imagePath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text('Error: ${item.name}', textAlign: TextAlign.center),
          );
        },
      );
    } else {
      // It's an asset path - use Image.asset()
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text('Error: ${item.name}', textAlign: TextAlign.center),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsCount = categoryItems.length;
    final double itemSize = 140.0;
    // Use finite list for < 3 items, infinite scroll for >= 3 items
    final int pageViewItemCount = itemsCount < 3
        ? itemsCount
        : virtualItemCount;

    return SizedBox(
      height: itemSize,
      child: PageView.builder(
        controller: controller,
        itemCount: pageViewItemCount,
        itemBuilder: (context, index) {
          if (itemsCount == 0) return const SizedBox.shrink();

          // For finite lists, use index directly; for infinite, use modulo
          final actualIndex = itemsCount < 3
              ? index
              : (index - initialPage) % itemsCount;
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
                      width: 1.0,
                      color: const Color.fromARGB(255, 231, 227, 227),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(
                      8.0,
                    ), // MODIFY FOR SCALING PLEASE
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildImage(item),
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
