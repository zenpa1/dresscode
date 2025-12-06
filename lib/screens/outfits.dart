// lib/screens/outfits.dart
import 'package:flutter/material.dart';
import 'package:dresscode/widgets/outfit_container.dart';
import 'package:dresscode/widgets/closet_navigation_row.dart';
import 'package:dresscode/utils/app_constants.dart';

// Convert OutfitsScreen to a StatefulWidget to manage the search state
class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({super.key});

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  // look at app_constants for this
  final List<Map<String, dynamic>> _allOutfits = kMockOutfits;

  List<Map<String, dynamic>> _filteredOutfits = [];

  @override
  void initState() {
    super.initState();
    _filteredOutfits = _allOutfits;
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allOutfits;
    } else {
      results = _allOutfits.where((outfit) {
        return outfit['name'].toString().toLowerCase().contains(
          enteredKeyword.toLowerCase(),
        );
      }).toList();
    }
    setState(() {
      _filteredOutfits = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: TextField(
                onChanged: (value) => _runFilter(value),
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
              child: _filteredOutfits.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredOutfits.length,
                      itemBuilder: (context, index) {
                        final outfit = _filteredOutfits[index];
                        return OutfitContainer(
                          outfitName: outfit['name'] as String,
                          clothingItems: outfit['items'] as List<String>,
                        );
                      },
                    )
                  : const Center(child: Text('No matching outfits found.')),
            ),
            const ClosetNavigationRow(),
          ],
        ),
      ),
    );
  }
}
