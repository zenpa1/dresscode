// lib/widgets/outfit_creation_dialog.dart (MODIFIED)
import 'package:flutter/material.dart';
import 'clothing_category_tile.dart';
import 'custom_button.dart';
// 🚨 NEW IMPORT: Access the central constant data
import 'package:dresscode/utils/app_constants.dart';

class OutfitCreationDialog extends StatelessWidget {
  const OutfitCreationDialog({super.key});

  // 🚨 MODIFIED: Use the constant map from the central utility file
  final Map<String, List<String>> _categories = kMockCategories;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        height: MediaQuery.of(context).size.height * 0.70,
        child: Column(
          children: <Widget>[
            // Dialog Title
            const Text(
              'Add a Clothing Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),

            // Collapsible Cards Section
            Expanded(
              child: ListView(
                children: _categories.entries.map((entry) {
                  // You might need to adjust the logic here if you want to use the list of
                  // strings directly, or if you need to pass individual item data.
                  return ClothingCategoryTile(
                    categoryName: entry.key,
                    availableItems: entry.value,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
