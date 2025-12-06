import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dresscode/widgets/clothing_card_row.dart';
import 'package:dresscode/widgets/button_row.dart';

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
  // Configuration Variables
  final int _numberOfRows = 4;
  final int _itemsPerRow = 8; // Actual number of items in your list
  final int _virtualItemCount = 10000; // Variables for Infinite Looping
  final int _initialPage = 4000; // Starts on Item 1 (index 0)
  final double _viewportFraction = 0.35;
  // Viewport fraction is set for 3 items: 1 centered, 2 partial on sides.

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
      // The listener is still needed here as it calls setState() on the parent State,
      // which is necessary to re-render the ClothingCard for its transformation logic.
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

    for (var controller in _pageControllers) {
      // Calculate a random target page. We add a few full cycles (e.g., 20)
      // to the current page number before adding the random item offset.
      final int newPageOffset =
          random.nextInt(_itemsPerRow) + (_itemsPerRow * 20);
      final int targetPage = (_initialPage + newPageOffset);

      // Animate to the new random page position
      controller.animateToPage(
        targetPage,
        duration: scrambleDuration,
        curve: scrambleCurve,
      );
    }
  }

  // --- Four Scrolling Carousels (Main Content) ---
  @override
  Widget build(BuildContext context) {
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
              children: <Widget>[
                // Use the new ClothingCardRow widget
                ClothingCardRow(
                  controller: _pageControllers[0],
                  itemsPerRow: _itemsPerRow,
                  virtualItemCount: _virtualItemCount,
                  initialPage: _initialPage,
                ),
                ClothingCardRow(
                  controller: _pageControllers[1],
                  itemsPerRow: _itemsPerRow,
                  virtualItemCount: _virtualItemCount,
                  initialPage: _initialPage,
                ),
                ClothingCardRow(
                  controller: _pageControllers[2],
                  itemsPerRow: _itemsPerRow,
                  virtualItemCount: _virtualItemCount,
                  initialPage: _initialPage,
                ),
                ClothingCardRow(
                  controller: _pageControllers[3],
                  itemsPerRow: _itemsPerRow,
                  virtualItemCount: _virtualItemCount,
                  initialPage: _initialPage,
                ),
              ],
            ),
          ),
          ButtonRow(onRandomize: _randomizeClothing),
        ],
      ),
    );
  }
}
