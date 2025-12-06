// lib/widgets/clothing_category_tile.dart (MODIFIED - Removed Add Card)
import 'package:flutter/material.dart';

class ClothingCategoryTile extends StatelessWidget {
  final String categoryName;
  // This now represents the list of existing items
  final List<String> availableItems;

  const ClothingCategoryTile({
    super.key,
    required this.categoryName,
    required this.availableItems,
  });

  // Placeholder function for deletion (don't code logic here)
  void _deleteItem(String item) {
    debugPrint('Functionality Placeholder: Delete item $item');
    // In a real app, this would trigger setState on the parent screen
  }

  // Placeholder function for adding item (don't code logic here)
  void _addItem() {
    debugPrint('Functionality Placeholder: Add item to $categoryName');
    // In a real app, this would trigger a different dialog or screen
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // Ensure the card takes up the full width in the dialog
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
      elevation: 0, // Remove elevation to make it look flat within the dialog
      color: Colors.grey[100],

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),

      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),

        // Header Text
        title: Text(
          categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey[800], // Darker text for contrast
          ),
        ),

        // Content that collapses/expands
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 12.0,
            ),
            child: Wrap(
              spacing: 8.0, // horizontal spacing
              runSpacing: 8.0, // vertical spacing
              // 🚨 REMOVED: The GestureDetector and Container for the Add (+) card is gone.

              // 1. EXISTING ITEM CARDS (Deletable on long press)
              children: availableItems.map((item) {
                return GestureDetector(
                  // 🚨 Long press functionality for deletion
                  onLongPress: () => _deleteItem(item),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for items
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        item
                            .split(' ')
                            .first, // Use first word for cleaner display
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
