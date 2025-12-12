// lib/screens/home_closet.dart (COMPLETE, FIXED, and SCALING RESTORED)

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dresscode/widgets/clothing_card_row.dart';
import 'package:dresscode/widgets/button_row.dart';
import 'package:dresscode/widgets/outfit_creation_dialog.dart';
import 'package:dresscode/utils/app_constants.dart';
import 'package:dresscode/models/clothing_item.dart' as models;
import 'package:dresscode/widgets/save_outfit_dialog.dart';
import 'package:dresscode/utils/snackbar_helper.dart';

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
  final Map<String, String>? outfitItemIds;

  const DigitalClosetScreen({super.key, this.outfitItemIds});

  @override
  State<DigitalClosetScreen> createState() => _DigitalClosetScreenState();
}
// --- END MISSING CLASS DEFINITIONS ---

class _DigitalClosetScreenState extends State<DigitalClosetScreen> {
  late final List<PageController> _pageControllers;

  // Cache of category items for use in _getCurrentSelectedItem
  final Map<String, List<ClothingItem>> _currentCategoryItems = {};

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

      // If outfit item IDs were provided, position the carousels to show those items
      if (widget.outfitItemIds != null) {
        _selectOutfitItems(widget.outfitItemIds!);
      }

      // Force a rebuild so widgets that depend on controller.page update
      // their scale immediately when the screen is first shown.
      setState(() {});
    });
  }

  /// Positions each carousel to display the outfit's selected items.
  void _selectOutfitItems(Map<String, String> itemIds) {
    final categoryToId = {
      AppCategories.hat: itemIds['hatId'],
      AppCategories.top: itemIds['topId'],
      AppCategories.bottom: itemIds['bottomId'],
      AppCategories.shoes: itemIds['shoesId'],
    };

    for (int i = 0; i < kCategoryOrder.length; i++) {
      final categoryName = kCategoryOrder[i];
      final itemId = categoryToId[categoryName];

      if (itemId == null) continue;

      final items =
          _currentCategoryItems[categoryName] ??
          _getItemsForCategory(categoryName);
      if (items.isEmpty) continue;

      // Find the index of the item with matching ID
      final itemIndex = items.indexWhere((item) => item.id == itemId);
      if (itemIndex == -1) continue;

      final controller = _pageControllers[i];
      if (!controller.hasClients) continue;

      // Jump to the page that would display this item
      final targetPage = _initialPage + itemIndex;
      controller.jumpToPage(targetPage);
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

      final categoryName = kCategoryOrder[i];
      final itemsCount = _currentCategoryItems[categoryName]?.length ?? 0;

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

    // Use the cached items from Hive
    final List<ClothingItem>? categoryItems =
        _currentCategoryItems[categoryName];

    if (categoryItems == null || categoryItems.isEmpty) return null;

    final actualItemIndex =
        (controller.page!.round() - _initialPage) % categoryItems.length;

    final selectedItem = categoryItems[actualItemIndex];
    debugPrint(
      '[GET_ITEM] Category: $categoryName, Index: $actualItemIndex/${categoryItems.length}, Item: ${selectedItem.name} (${selectedItem.category})',
    );
    return selectedItem;
  }

  // Logic to extract items and display the SaveOutfitDialog
  void _showSaveOutfitDialog() {
    final List<ClothingItem> itemsToSave = [];

    for (int i = 0; i < _numberOfRows; i++) {
      final item = _getCurrentSelectedItem(i);
      if (item != null) {
        itemsToSave.add(item);

        debugPrint(
          '[OUTFIT SAVE] Items being saved: ${itemsToSave.map((i) => '${i.category}:${i.name}').join(', ')}',
        );
      }
    }

    if (itemsToSave.isEmpty) {
      SnackbarHelper.showSnackbar(
        context: context,
        message: 'Please select at least one item to save.',
        duration: const Duration(seconds: 1),
      );
      return;
    }

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

  // --- Convert Hive models to mock ClothingItem format for display ---
  List<ClothingItem> _getItemsForCategory(String category) {
    try {
      final hiveBox = Hive.box<models.ClothingItem>('closet_box');
      final hiveItems = hiveBox.values
          .where((item) => item.category == category)
          .map(
            (hiveItem) => ClothingItem(
              id: hiveItem.id,
              name: hiveItem.name,
              imagePath: hiveItem.imagePath,
              category: hiveItem.category,
            ),
          )
          .toList();

      return hiveItems;
    } catch (e) {
      debugPrint('Error getting items for category $category: $e');
      return [];
    }
  }

  // --- Four Scrolling Carousels (Main Content) ---
  @override
  Widget build(BuildContext context) {
    try {
      final closetBox = Hive.box<models.ClothingItem>('closet_box');
      return ValueListenableBuilder<Box<models.ClothingItem>>(
        valueListenable: closetBox.listenable(),
        builder: (context, box, _) {
          final List<Widget> cardRows = kCategoryOrder.asMap().entries.map((
            entry,
          ) {
            final index = entry.key;
            final categoryName = entry.value;

            final List<ClothingItem> categoryItems = _getItemsForCategory(
              categoryName,
            );

            // Cache the items for use in _getCurrentSelectedItem
            _currentCategoryItems[categoryName] = categoryItems;

            if (index >= _pageControllers.length) {
              return const SizedBox.shrink();
            }

            if (categoryItems.isEmpty) {
              return SizedBox(
                height: 140.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 12.0,
                  ),
                  child: GestureDetector(
                    onTap: _showClothingCardDialog,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add Item',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
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
        },
      );
    } catch (e) {
      debugPrint('Error in build: $e');
      // Fallback UI if Hive is not available
      return Scaffold(body: Center(child: Text('Error loading closet: $e')));
    }
  }
}
