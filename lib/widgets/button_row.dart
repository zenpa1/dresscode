// lib/widgets/button_row.dart (MODIFIED to include onSave callback)

import 'package:flutter/material.dart';
import 'package:dresscode/screens/outfits.dart';
import 'custom_button.dart';

class ButtonRow extends StatelessWidget {
  final VoidCallback? onRandomize;
  final VoidCallback? onSave;

  const ButtonRow({super.key, this.onRandomize, this.onSave});

  // 2. Navigation Function
  void _navigateToOutfits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Use OutfitsScreen class name (defined in outfits.dart)
        builder: (context) => OutfitsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      padding: const EdgeInsets.all(2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. SAVE Button (Connected to the new onSave callback)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CustomButton(
                text: 'SAVE',
                onPressed: (ctx) {
                  onSave?.call();
                },
              ),
            ),
          ),

          // 2. OUTFITS Button (Navigation)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CustomButton(
                text: 'OUTFITS',
                // Hookup: Use anonymous function to correctly pass context to the method
                onPressed: (ctx) => _navigateToOutfits(ctx),
              ),
            ),
          ),

          // 3. RANDOMIZE Button (Connected to the onRandomize callback)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CustomButton(
                text: 'RANDOMIZE',
                onPressed: (ctx) {
                  onRandomize?.call();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
