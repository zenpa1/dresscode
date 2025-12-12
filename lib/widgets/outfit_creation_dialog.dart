import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'clothing_category_tile.dart';
import 'custom_button.dart';
import 'package:dresscode/utils/app_constants.dart';
import 'package:dresscode/models/clothing_item.dart' as models;
import 'add_item_dialog.dart';

class OutfitCreationDialog extends StatelessWidget {
  const OutfitCreationDialog({super.key});

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
    final closetBox = Hive.box<models.ClothingItem>('closet_box');

    // Group items by category for display in the expandable tiles
    final Map<String, List<ClothingItem>> categories = {
      for (final cat in kCategoryOrder) cat: <ClothingItem>[],
    };
    for (final item in closetBox.values) {
      categories
          .putIfAbsent(item.category, () => [])
          .add(
            ClothingItem(
              id: item.id,
              name: item.name,
              imagePath: item.imagePath,
              category: item.category,
            ),
          );
    }

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
                children: categories.entries.map((entry) {
                  return ClothingCategoryTile(
                    categoryName: entry.key,
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
                border: Border(),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: CustomButton(
                text: 'ADD AN ITEM',
                onPressed: (_) => _onAddItemPressed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
