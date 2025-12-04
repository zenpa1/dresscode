import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const DigitalClosetApp());
}

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

  // --- Helper Widget for Bottom Action Buttons (Matches Mockup Style) ---

  Widget _buildActionButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            debugPrint('$text button pressed');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          child: Text(text),
        ),
      ),
    );
  }

  // --- Carousel Item with Scale and Vertical Offset Transformation ---

  Widget _buildItemWithTransform({
    required int index,
    required PageController controller,
    required double itemSize,
  }) {
    double value = 0.0;

    double currentPage = controller.hasClients && controller.page != null
        ? controller.page!
        : _initialPage.toDouble();

    // Calculate the distance from the center page
    value = currentPage - index;
    value = value.clamp(-1.0, 1.0);

    // Calculate the real item index for display/content
    final int realIndex = index % _itemsPerRow;

    // --- Transformation Properties ---
    const double minScale = 0.35;
    const double maxVerticalOffset = 10.0;
    // 1. Scale: Larger in center (1.0), smaller on sides (minScale)
    final double scale = 1.0 - (value.abs() * (1.0 - minScale));
    // 2. Vertical Offset: Move item UP (negative Y) proportionally to distance from center
    final double offsetY = -value.abs() * maxVerticalOffset;

    return Center(
      child: Transform(
        // Apply both Translate (vertical offset) and Scale
        transform: Matrix4.identity()
          ..translate(0.0, offsetY)
          ..scale(scale, scale),

        alignment: FractionalOffset.center,
        child: Container(
          width: itemSize,
          height: itemSize,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              'Item ${realIndex + 1}',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widget for the Scroll Row (Carousel) ---
  Widget _buildCarouselRow(int rowNumber, PageController controller) {
    const double itemSize = 140.0;
    return Padding(
      // Reduced vertical padding
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: SizedBox(
        // Height adjusted based on item size and offset
        height: itemSize,
        child: PageView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          // Enables infinite looping
          itemCount: _virtualItemCount,
          itemBuilder: (context, index) {
            return _buildItemWithTransform(
              index: index,
              controller: controller,
              itemSize: itemSize,
            );
          },
        ),
      ),
    );
  }

  // --- Four Scrolling Carousels (Main Content) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.all(2),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildCarouselRow(1, _pageControllers[0]),
                _buildCarouselRow(2, _pageControllers[1]),
                _buildCarouselRow(3, _pageControllers[2]),
                _buildCarouselRow(4, _pageControllers[3]),
              ],
            ),
          ),
          // --- Bottom Action Buttons (SAVE, OUTFITS, RANDOMIZE) ---
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.all(2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildActionButton('SAVE'),
                _buildActionButton('OUTFITS'),
                _buildActionButton('RANDOMIZE'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
