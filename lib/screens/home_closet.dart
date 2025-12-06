// lib/home_closet.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dresscode/widgets/clothing_card_row.dart';
import 'package:dresscode/widgets/button_row.dart';
import 'package:dresscode/widgets/outfit_creation_dialog.dart';
import 'package:dresscode/utils/app_constants.dart'; // NEW IMPORT

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
        itemsPerRow: itemsCount, // Now using the actual item count
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
          ButtonRow(onRandomize: _randomizeClothing),
        ],
      ),
    );
  }
}
