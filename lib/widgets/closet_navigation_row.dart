import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'package:dresscode/screens/home_closet.dart';

class ClosetNavigationRow extends StatelessWidget {
  const ClosetNavigationRow({super.key});

  void _navigateToCloset(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DigitalClosetScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Outer Container Styling
    return Container(
      margin: const EdgeInsets.only(bottom: 20),

      // Keep padding for internal spacing consistency
      padding: const EdgeInsets.all(2),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CustomButton(
                text: 'CLOSET',
                onPressed: (ctx) => _navigateToCloset(ctx),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
