// lib/widgets/outfit_creation_dialog.dart (Type Fix for ClothingItem)

import 'package:flutter/material.dart';
import 'clothing_category_tile.dart';
import 'custom_button.dart';
// 🚨 NEW IMPORT NEEDED: Bring in the ClothingItem class definition
import 'package:dresscode/utils/app_constants.dart';
import 'add_item_dialog.dart';

class OutfitCreationDialog extends StatelessWidget {
  const OutfitCreationDialog({super.key});

  // 🚨 FIX 1: Change the field type to List<ClothingItem>
  final Map<String, List<ClothingItem>> _categories = kMockCategories;

  // MODIFIED FUNCTIONALITY: Opens the AddItemDialog
  void _onAddItemPressed(BuildContext context) {
    debugPrint('ADD AN ITEM button pressed. Opening AddItemDialog.');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddItemDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 0),
        height: MediaQuery.of(context).size.height * 0.70,
        child: Column(
          children: <Widget>[
            // Dialog Header (Unchanged)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const Text(
                    'Create New Outfit',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 20),
                ],
              ),
            ),

            // Collapsible Cards Section
            Expanded(
              child: ListView(
                children: _categories.entries.map((entry) {
                  return ClothingCategoryTile(
                    categoryName: entry.key,
                    // 🚨 FIX 2: availableItems now passes List<ClothingItem>
                    // Note: ClothingCategoryTile MUST be updated next.
                    availableItems: entry.value,
                  );
                }).toList(),
              ),
            ),

            // Full-Width Button Area (Unchanged)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1.0),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: CustomButton(
                text: 'ADD AN ITEM',
                // Updated to correctly call the function with context
                onPressed: (_) => _onAddItemPressed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
