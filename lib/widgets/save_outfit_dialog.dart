// lib/widgets/save_outfit_dialog.dart (MODIFIED for centered text)

import 'package:flutter/material.dart';
import 'custom_button.dart';

class SaveOutfitDialog extends StatefulWidget {
  // 🚨 REQUIRED PARAMETER: The list of items to be saved in this outfit
  final List<String> itemsToSave;

  const SaveOutfitDialog({super.key, required this.itemsToSave});

  @override
  State<SaveOutfitDialog> createState() => _SaveOutfitDialogState();
}

class _SaveOutfitDialogState extends State<SaveOutfitDialog> {
  final TextEditingController _nameController = TextEditingController(
    text: 'My New Outfit',
  );

  static const double _borderRadius = 16.0;

  // Define constraints for the edit icon to ensure centering
  // The suffix icon has a size of 20 and is constrained by 25.
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
                // Text remains centered
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

                  // 🚨 NEW: Invisible prefix to push the text back to center
                  prefixIcon: const SizedBox.shrink(),
                  prefixIconConstraints: _iconConstraints,

                  // Suffix icon for the edit indicator
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

            // 2. Center Item List Display (Remaining content is unchanged)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(color: Colors.grey[50]),
                child: ListView.builder(
                  itemCount: widget.itemsToSave.length,
                  itemBuilder: (context, index) {
                    final item = widget.itemsToSave[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.black87,
                      ),
                      title: Text(item, style: const TextStyle(fontSize: 14)),
                    );
                  },
                ),
              ),
            ),

            // 3. Bottom Button Row (Unchanged)
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
