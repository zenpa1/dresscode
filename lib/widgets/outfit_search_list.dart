import 'package:flutter/material.dart';
import 'package:dresscode/widgets/outfit_container.dart'; // Import Step 1B

class OutfitSearchBarAndList extends StatefulWidget {
  const OutfitSearchBarAndList({super.key});

  @override
  State<OutfitSearchBarAndList> createState() => _OutfitSearchBarAndListState();
}

class _OutfitSearchBarAndListState extends State<OutfitSearchBarAndList> {
  // All outfit data is now managed here
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

  // Search logic function
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
    return Column(
      children: <Widget>[
        // Search Bar (TextField)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
              labelText: 'Search Outfits by Title',
              hintText: 'e.g., Casual',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 15.0,
              ),
            ),
          ),
        ),

        // Filtered List View
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
              : const Center(
                  child: Text(
                    'No results found for that outfit title.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        ),
      ],
    );
  }
}
