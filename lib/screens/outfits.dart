// lib/screens/outfits.dart
import 'package:flutter/material.dart';
import 'package:dresscode/widgets/outfit_container.dart'; // Import for list items
import 'package:dresscode/widgets/closet_navigation_row.dart';

// Convert OutfitsScreen to a StatefulWidget to manage the search state
class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({super.key});

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  // Placeholder data and filtering logic (moved from OutfitSearchBarAndList)
  final List<Map<String, dynamic>> _allOutfits = const [
    {
      'name': 'Casual Weekend',
      'items': ['Blue Tee', 'Denim Jeans', 'White Sneakers'],
    },
    {
      'name': 'Office Smart',
      'items': ['White Shirt', 'Grey Trousers', 'Black Blazer', 'Loafers'],
    },
    {
      'name': 'Gym Ready',
      'items': ['Sports Bra', 'Black Leggings', 'Running Shoes'],
    },
    {
      'name': 'Casual Friday',
      'items': ['Polo', 'Khakis', 'Boat Shoes'],
    },
  ];

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
  // End of logic moved from OutfitSearchBarAndList

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // 1. FIXED SEARCH BAR AREA
            Container(
              // Top spacing (margin: const EdgeInsets.only(bottom: 40) is NOT used here,
              // as the search bar itself provides visual spacing.
              // We'll use padding for the layout.)
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

            // 2. SCROLLABLE CONTENT (EXPANDED)
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

            // 3. FIXED BOTTOM BUTTON ROW (Pushed to the bottom by the Expanded widget)
            const ClosetNavigationRow(),
          ],
        ),
      ),
    );
  }
}
