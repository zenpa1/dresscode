// lib/home_closet.dart (MODIFIED to access SaveOutfitDialog)
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dresscode/widgets/clothing_card_row.dart';
import 'package:dresscode/widgets/button_row.dart';
import 'package:dresscode/widgets/outfit_creation_dialog.dart';
import 'package:dresscode/utils/app_constants.dart';
import 'package:dresscode/widgets/save_outfit_dialog.dart';

class DigitalClosetApp extends StatelessWidget {
  const DigitalClosetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Closet',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DigitalClosetScreen(),
    );
  }
}

class DigitalClosetScreen extends StatefulWidget {
  const DigitalClosetScreen({super.key});

  @override
  State<DigitalClosetScreen> createState() => _DigitalClosetScreenState();
}

class _DigitalClosetScreenState extends State<DigitalClosetScreen> {
  late final List<PageController> _pageControllers;

  // Configuration Variables based on central data
  final int _numberOfRows = kCategoryOrder.length;
  final int _virtualItemCount = 10000;
  final int _initialPage = 4000;
  final double _viewportFraction = 0.35;

  @override
  void initState() {
    super.initState();

    _pageControllers = List.generate(
      _numberOfRows,
      (index) => PageController(
        viewportFraction: _viewportFraction,
        initialPage: _initialPage,
      ),
    );

    // Listener to force redraw on scroll for the transformation effect
    for (var controller in _pageControllers) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (var controller in _pageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _randomizeClothing() {
    final Random random = Random();
    const Duration scrambleDuration = Duration(milliseconds: 700);
    const Curve scrambleCurve = Curves.easeInOutQuad;

    for (int i = 0; i < _pageControllers.length; i++) {
      final controller = _pageControllers[i];

      // Get the number of items for the current category row from central data
      final categoryName = kCategoryOrder[i];
      final itemsCount = kMockCategories[categoryName]?.length ?? 0;

      if (itemsCount > 0) {
        // Calculate a random target page based on itemsCount
        final int newPageOffset =
            random.nextInt(itemsCount) + (itemsCount * 20);
        final int targetPage = (_initialPage + newPageOffset);

        controller.animateToPage(
          targetPage,
          duration: scrambleDuration,
          curve: scrambleCurve,
        );
      }
    }
  }

  // Helper function to get the currently selected item in a row
  String? _getCurrentSelectedItem(int rowIndex) {
    if (rowIndex >= _pageControllers.length) return null;

    final controller = _pageControllers[rowIndex];
    if (!controller.hasClients || controller.page == null) return null;

    final categoryName = kCategoryOrder[rowIndex];
    final categoryItems = kMockCategories[categoryName];

    if (categoryItems == null || categoryItems.isEmpty) return null;

    // Calculate the index of the selected item within the category list
    final actualItemIndex =
        (controller.page!.round() - _initialPage) % categoryItems.length;

    return '${categoryName}: ${categoryItems[actualItemIndex]}';
  }

  // 🚨 NEW FUNCTION: Logic to extract items and display the SaveOutfitDialog
  void _showSaveOutfitDialog() {
    final List<String> itemsToSave = [];

    // 1. Extract the selected item from each row
    for (int i = 0; i < _numberOfRows; i++) {
      final item = _getCurrentSelectedItem(i);
      if (item != null) {
        itemsToSave.add(item);
      }
    }

    if (itemsToSave.isEmpty) {
      // Optional: Show a snackbar or simple alert if no items are selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one item to save.'),
        ),
      );
      return;
    }

    // 2. Display the SaveOutfitDialog, passing the list of items
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SaveOutfitDialog(itemsToSave: itemsToSave);
      },
    ).then((confirmed) {
      if (confirmed == true) {
        // Handle post-save logic (e.g., clear selection, show confirmation)
        debugPrint('Outfit successfully confirmed and saved!');
      }
    });
  }

  // This is a placeholder and should be removed if ClothingCardRow handles card tap externally
  void _showClothingCardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const OutfitCreationDialog();
      },
    );
  }

  // --- Four Scrolling Carousels (Main Content) ---
  @override
  Widget build(BuildContext context) {
    // Dynamically generate rows based on the category list
    final List<Widget> cardRows = kCategoryOrder.asMap().entries.map((entry) {
      final index = entry.key;
      final categoryName = entry.value;

      final itemsCount = kMockCategories[categoryName]?.length ?? 0;

      if (index >= _pageControllers.length || itemsCount == 0) {
        return const SizedBox.shrink();
      }

      return ClothingCardRow(
        controller: _pageControllers[index],
        itemsPerRow: itemsCount,
        virtualItemCount: _virtualItemCount,
        initialPage: _initialPage,
        onCardTap: _showClothingCardDialog,
      );
    }).toList();

    return Scaffold(
      body: Column(
        children: <Widget>[
          // Top padding/margin area
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.all(2),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cardRows,
            ),
          ),
          // 🚨 CONNECTION: Pass the save function to the ButtonRow
          // NOTE: You must update ButtonRow to accept an 'onSave' callback.
          ButtonRow(
            onRandomize: _randomizeClothing,
            onSave:
                _showSaveOutfitDialog, // Assuming ButtonRow now accepts this
          ),
        ],
      ),
    );
  }
}
