import 'package:flutter/material.dart';
import 'package:dresscode/widgets/outfit_container.dart';
import 'package:dresscode/widgets/outfit_clothing_card.dart';

class OutfitDetailScreen extends StatelessWidget {
  final String outfitName;
  final List<OutfitDisplayItem> items;

  const OutfitDetailScreen({
    super.key,
    required this.outfitName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(outfitName)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutfitClothingCard(
                    label: item.label,
                    imagePath: item.imagePath,
                    itemSize: 140,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
