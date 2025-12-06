import 'package:flutter/material.dart';
import 'package:dresscode/screens/outfits.dart';
import 'custom_button.dart';

class ButtonRow extends StatelessWidget {
  final VoidCallback? onRandomize;

  const ButtonRow({super.key, this.onRandomize});

  // 2. Navigation Function
  void _navigateToOutfits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Use OutfitsScreen class name (defined in outfits.dart)
        builder: (context) => const OutfitsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Helper function for buttons that don't need context or have simple actions
    void defaultOnPressed(BuildContext ctx) {
      debugPrint('Button pressed');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      padding: const EdgeInsets.all(2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CustomButton(text: 'SAVE', onPressed: defaultOnPressed),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CustomButton(
                text: 'OUTFITS',
                // 3. Hookup: Use anonymous function to correctly pass context to the method
                onPressed: (ctx) => _navigateToOutfits(ctx),
              ),
            ),
          ),
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
