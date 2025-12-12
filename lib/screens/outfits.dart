// lib/screens/outfits.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:dresscode/models/outfit.dart';
import 'package:dresscode/utils/app_constants.dart';
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
  late final Map<String, String> _namesById;
  late final Map<String, String> _imagesById;

  @override
  void initState() {
    super.initState();
    _namesById = _buildNameIndex();
    _imagesById = _buildImageIndex();
  }

  Map<String, String> _buildNameIndex() {
    final map = <String, String>{};
    for (final entry in kMockCategories.entries) {
      for (final item in entry.value) {
        map[item.id] = item.name;
      }
    }
    return map;
  }

  Map<String, String> _buildImageIndex() {
    final map = <String, String>{};
    for (final entry in kMockCategories.entries) {
      for (final item in entry.value) {
        map[item.id] = item.imagePath;
      }
    }
    return map;
  }

  List<Outfit> _filter(List<Outfit> outfits) {
    if (_searchTerm.trim().isEmpty) return outfits;
    final q = _searchTerm.toLowerCase();
    return outfits
        .where((o) => (o.name ?? '').toLowerCase().contains(q))
        .toList();
  }

  List<OutfitDisplayItem> _itemsFor(Outfit o) {
    OutfitDisplayItem? itemFor(String? id, String fallback) {
      if (id == null) return null;
      final name = _namesById[id] ?? fallback;
      final image = _imagesById[id];
      return OutfitDisplayItem(label: name, imagePath: image);
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
    final box = Hive.box<Outfit>('outfits_box');

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
                valueListenable: box.listenable(),
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
                      final items = _itemsFor(outfit);
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
              ),
            ),
            const ClosetNavigationRow(),
          ],
        ),
      ),
    );
  }
}
