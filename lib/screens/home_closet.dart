// lib/screens/home_closet.dart (COMPLETE, FIXED, and SCALING RESTORED)

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dresscode/widgets/clothing_card_row.dart';
import 'package:dresscode/widgets/button_row.dart';
import 'package:dresscode/widgets/outfit_creation_dialog.dart';
import 'package:dresscode/utils/app_constants.dart';
import 'package:dresscode/widgets/save_outfit_dialog.dart';

// --- MISSING CLASS DEFINITIONS (Fixes "Type not found" error) ---
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
// --- END MISSING CLASS DEFINITIONS ---

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

    // SCALING RESTORATION
    for (var controller in _pageControllers) {
      controller.addListener(() => setState(() {}));
    }

    // Ensure controllers have a valid `page` and trigger the initial
    // scaling calculation after the first frame when the PageViews are
    // attached to the tree.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var controller in _pageControllers) {
        if (controller.hasClients) {
          controller.jumpToPage(_initialPage);
        }
      }
      // Force a rebuild so widgets that depend on controller.page update
      // their scale immediately when the screen is first shown.
      setState(() {});
    });
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

      final categoryName = kCategoryOrder[i];
      final itemsCount = kMockCategories[categoryName]?.length ?? 0;

      if (itemsCount > 0) {
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
  ClothingItem? _getCurrentSelectedItem(int rowIndex) {
    if (rowIndex >= _pageControllers.length) return null;

    final controller = _pageControllers[rowIndex];
    if (!controller.hasClients || controller.page == null) return null;

    final categoryName = kCategoryOrder[rowIndex];
    final List<ClothingItem>? categoryItems = kMockCategories[categoryName];

    if (categoryItems == null || categoryItems.isEmpty) return null;

    final actualItemIndex =
        (controller.page!.round() - _initialPage) % categoryItems.length;

    return categoryItems[actualItemIndex];
  }

  // Logic to extract items and display the SaveOutfitDialog
  void _showSaveOutfitDialog() {
    final List<ClothingItem> itemsToSave = [];

    for (int i = 0; i < _numberOfRows; i++) {
      final item = _getCurrentSelectedItem(i);
      if (item != null) {
        itemsToSave.add(item);
      }
    }

    if (itemsToSave.isEmpty) {}

    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SaveOutfitDialog(itemsToSave: itemsToSave);
      },
    ).then((confirmed) {
      if (confirmed == true) {
        debugPrint('Outfit successfully confirmed and saved!');
      }
    });
  }

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
    final List<Widget> cardRows = kCategoryOrder.asMap().entries.map((entry) {
      final index = entry.key;
      final categoryName = entry.value;

      final List<ClothingItem>? categoryItems = kMockCategories[categoryName];

      if (index >= _pageControllers.length ||
          categoryItems == null ||
          categoryItems.isEmpty) {
        return const SizedBox.shrink();
      }

      return ClothingCardRow(
        controller: _pageControllers[index],
        categoryItems: categoryItems,
        virtualItemCount: _virtualItemCount,
        initialPage: _initialPage,
        onCardTap: _showClothingCardDialog,
      );
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) =>
            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        child: Column(
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
            ButtonRow(
              onRandomize: _randomizeClothing,
              onSave: _showSaveOutfitDialog,
            ),
          ],
        ),
      ),
    );
  }
}
