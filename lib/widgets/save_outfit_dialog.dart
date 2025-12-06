// lib/widgets/save_outfit_dialog.dart (Scaling fix using internal padding/margin)

import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'package:dresscode/utils/app_constants.dart';

// A reusable widget to represent a small item card visually
class _MiniClothingCard extends StatelessWidget {
  final ClothingItem item;

  const _MiniClothingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Center(
        child: Container(
          width: 100, // Fixed width for the card
          height: 100, // Fixed height for a square card
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 3,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(
              9.0,
            ), //MODIFY THIS IMAGE FOR SCALING PLEASE
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.imagePath,
                fit: BoxFit
                    .contain, // Use .contain to ensure the whole image is visible
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SaveOutfitDialog extends StatefulWidget {
  // ... (Rest of SaveOutfitDialog code remains unchanged) ...
  final List<ClothingItem> itemsToSave;

  const SaveOutfitDialog({super.key, required this.itemsToSave});

  @override
  State<SaveOutfitDialog> createState() => _SaveOutfitDialogState();
}

class _SaveOutfitDialogState extends State<SaveOutfitDialog> {
  // ... (Rest of SaveOutfitDialog code remains unchanged) ...

  final TextEditingController _nameController = TextEditingController(
    text: 'My New Outfit',
  );

  static const double _borderRadius = 16.0;
  static const BoxConstraints _iconConstraints = BoxConstraints(
    minHeight: 0,
    minWidth: 25,
  );

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 0),
        height: MediaQuery.of(context).size.height * 0.70,
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          children: <Widget>[
            // 1. Editable Title Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Outfit Name',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: const SizedBox.shrink(),
                  prefixIconConstraints: _iconConstraints,
                  suffixIcon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.grey,
                  ),
                  suffixIconConstraints: _iconConstraints,
                ),
              ),
            ),
            const Divider(height: 20),

            // 2. Center Item Display (Vertical Stack of Cards)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widget.itemsToSave.map((item) {
                      return _MiniClothingCard(item: item);
                    }).toList(),
                  ),
                ),
              ),
            ),

            // 3. Bottom Button Row
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'CANCEL',
                      onPressed: (ctx) => Navigator.pop(ctx, false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      text: 'CONFIRM',
                      onPressed: (ctx) {
                        final outfitName = _nameController.text;
                        debugPrint(
                          'Confirmed saving outfit: $outfitName with ${widget.itemsToSave.length} items',
                        );
                        Navigator.pop(ctx, true);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
