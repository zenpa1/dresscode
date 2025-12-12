// lib/screens/outfits.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:dresscode/models/outfit.dart';
import 'package:dresscode/models/clothing_item.dart' as models;
import 'package:dresscode/widgets/outfit_container.dart';
import 'package:dresscode/widgets/closet_navigation_row.dart';
import 'package:dresscode/screens/outfit_detail.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({super.key});

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  String _searchTerm = '';

  List<Outfit> _filter(List<Outfit> outfits) {
    if (_searchTerm.trim().isEmpty) return outfits;
    final q = _searchTerm.toLowerCase();
    return outfits
        .where((o) => (o.name ?? '').toLowerCase().contains(q))
        .toList();
  }

  List<OutfitDisplayItem> _itemsFor(
    Outfit o,
    Map<String, models.ClothingItem> itemsById,
  ) {
    OutfitDisplayItem? itemFor(String? id, String fallback) {
      if (id == null) return null;
      final item = itemsById[id];
      if (item == null)
        return OutfitDisplayItem(label: fallback, imagePath: null);
      return OutfitDisplayItem(label: item.name, imagePath: item.imagePath);
    }

    final items = <OutfitDisplayItem>[];
    final hat = itemFor(o.hatId, 'Hat');
    final top = itemFor(o.topId, 'Top');
    final bottom = itemFor(o.bottomId, 'Bottom');
    final shoes = itemFor(o.shoesId, 'Shoes');

    for (final x in [hat, top, bottom, shoes]) {
      if (x != null) items.add(x);
    }

    if (items.isEmpty) {
      items.add(const OutfitDisplayItem(label: 'No items', imagePath: null));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final outfitsBox = Hive.box<Outfit>('outfits_box');
    final closetBox = Hive.box<models.ClothingItem>('closet_box');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchTerm = value),
                decoration: InputDecoration(
                  labelText: 'Search Outfits by Title',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: closetBox.listenable(),
                builder: (context, Box<models.ClothingItem> closet, _) {
                  final itemsById = {
                    for (final item in closet.values) item.id: item,
                  };

                  return ValueListenableBuilder(
                    valueListenable: outfitsBox.listenable(),
                    builder: (context, Box<Outfit> b, _) {
                      final outfits = _filter(b.values.toList());
                      if (outfits.isEmpty) {
                        return const Center(
                          child: Text('No matching outfits found.'),
                        );
                      }
                      // Sort newest first
                      outfits.sort((a, b) => b.savedAt.compareTo(a.savedAt));
                      return ListView.builder(
                        itemCount: outfits.length,
                        itemBuilder: (context, index) {
                          final outfit = outfits[index];
                          final items = _itemsFor(outfit, itemsById);
                          final name = outfit.name ?? 'Untitled Outfit';
                          return OutfitContainer(
                            outfitName: name,
                            items: items,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => OutfitDetailScreen(
                                    outfitId: outfit.id,
                                    outfitName: name,
                                    items: items,
                                    hatId: outfit.hatId,
                                    topId: outfit.topId,
                                    bottomId: outfit.bottomId,
                                    shoesId: outfit.shoesId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const ClosetNavigationRow(),
          ],
        ),
      ),
    );
  }
}
