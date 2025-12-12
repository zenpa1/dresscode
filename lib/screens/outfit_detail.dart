import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:dresscode/models/outfit.dart';
import 'package:dresscode/widgets/outfit_container.dart';
import 'package:dresscode/widgets/custom_button.dart';
import 'package:dresscode/screens/outfits.dart';
import 'package:dresscode/screens/home_closet.dart';
import 'package:dresscode/utils/snackbar_helper.dart';

// Full-screen variant of the SaveOutfitDialog UI. Receives the already
// assembled outfit data as `outfitName` and a list of `OutfitDisplayItem`.
class OutfitDetailScreen extends StatefulWidget {
  final String outfitId;
  final String outfitName;
  final List<OutfitDisplayItem> items;
  final String? hatId;
  final String? topId;
  final String? bottomId;
  final String? shoesId;

  const OutfitDetailScreen({
    super.key,
    required this.outfitId,
    required this.outfitName,
    required this.items,
    this.hatId,
    this.topId,
    this.bottomId,
    this.shoesId,
  });

  @override
  State<OutfitDetailScreen> createState() => _OutfitDetailScreenState();
}

class _OutfitDetailScreenState extends State<OutfitDetailScreen> {
  late final TextEditingController _nameController;
  late List<OutfitDisplayItem> _items;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.outfitName);
    _items = List<OutfitDisplayItem>.from(widget.items);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showEditNameDialog() async {
    final controller = TextEditingController(text: _nameController.text);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dCtx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(dCtx).size.width * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Outfit Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Outfit name'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'CANCEL',
                      onPressed: (ctx2) => Navigator.of(dCtx).pop(false),
                      backgroundColor: Colors.grey.shade200,
                      textColor: Colors.black87,
                      borderColor: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      text: 'SAVE',
                      onPressed: (ctx2) => Navigator.of(dCtx).pop(true),
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      setState(() {
        _nameController.text = controller.text.trim();
      });
    }
  }

  Future<void> _editItemName(int index) async {
    final current = _items[index].label;
    final controller = TextEditingController(text: current);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dCtx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(dCtx).size.width * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Item Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Item name'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'CANCEL',
                      onPressed: (ctx2) => Navigator.of(dCtx).pop(false),
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      borderColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      text: 'SAVE',
                      onPressed: (ctx2) => Navigator.of(dCtx).pop(true),
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      setState(() {
        final old = _items[index];
        _items[index] = OutfitDisplayItem(
          label: controller.text.trim(),
          imagePath: old.imagePath,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) =>
            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        child: Column(
          children: [
            // Top title row (centered) with edit icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 16.0,
              ),
              color: Colors.white,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      _nameController.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: _showEditNameDialog,
                    ),
                  ),
                ],
              ),
            ),

            // Main scrollable area showing a vertical stack of the outfit items
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _items.asMap().entries.map((entry) {
                      final i = entry.key;
                      final it = entry.value;
                      return _MiniDisplayCard(
                        item: it,
                        onEditName: () => _editItemName(i),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Bottom action row: EDIT, OUTFITS, DELETE (uses same spacing as home_closet)
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              padding: const EdgeInsets.all(2),
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CustomButton(
                        text: 'EDIT',
                        onPressed: (ctx) {
                          // Build a map of outfit item IDs and navigate to closet
                          final outfitItemIds = <String, String>{};
                          if (widget.hatId != null) {
                            outfitItemIds['hatId'] = widget.hatId!;
                          }
                          if (widget.topId != null) {
                            outfitItemIds['topId'] = widget.topId!;
                          }
                          if (widget.bottomId != null) {
                            outfitItemIds['bottomId'] = widget.bottomId!;
                          }
                          if (widget.shoesId != null) {
                            outfitItemIds['shoesId'] = widget.shoesId!;
                          }

                          Navigator.of(ctx).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => DigitalClosetScreen(
                                outfitItemIds: outfitItemIds.isNotEmpty
                                    ? outfitItemIds
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CustomButton(
                        text: 'OUTFITS',
                        onPressed: (ctx) {
                          // Replace the current detail route with the Outfits screen
                          // so that "CLOSET" (which pops) returns to the closet
                          Navigator.pushReplacement(
                            ctx,
                            MaterialPageRoute(builder: (c) => OutfitsScreen()),
                          );
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CustomButton(
                        text: 'DELETE',
                        onPressed: (ctx) async {
                          final confirmed = await showDialog<bool>(
                            context: ctx,
                            builder: (dCtx) => Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                width: MediaQuery.of(dCtx).size.width * 0.85,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Delete Outfit',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Are you sure you want to delete this outfit?',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            text: 'CANCEL',
                                            onPressed: (ctx2) =>
                                                Navigator.of(dCtx).pop(false),
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            borderColor: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: CustomButton(
                                            text: 'DELETE',
                                            onPressed: (ctx2) =>
                                                Navigator.of(dCtx).pop(true),
                                            backgroundColor:
                                                Colors.red.shade700,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );

                          if (confirmed == true) {
                            try {
                              final box = Hive.box<Outfit>('outfits_box');
                              await box.delete(widget.outfitId);

                              // Close the detail screen after delete confirmation.
                              Navigator.of(ctx).pop();
                              SnackbarHelper.showSnackbar(
                                context: ctx,
                                message: 'Outfit deleted',
                                duration: const Duration(seconds: 1),
                              );
                            } catch (e) {
                              SnackbarHelper.showSnackbar(
                                context: ctx,
                                message: 'Error deleting outfit: $e',
                              );
                            }
                          }
                        },
                        backgroundColor: Colors.red.shade700,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniDisplayCard extends StatelessWidget {
  final OutfitDisplayItem item;
  final VoidCallback? onEditName;

  const _MiniDisplayCard({required this.item, this.onEditName});

  @override
  Widget build(BuildContext context) {
    Widget _fallbackLabel() {
      return Center(
        child: Text(
          item.label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      );
    }

    Widget buildImage(String path) {
      final isFilePath =
          path.startsWith('/') ||
          path.contains(RegExp(r'^[A-Za-z]:\\')) ||
          path.contains('/data/') ||
          path.contains('app_flutter');

      if (isFilePath && File(path).existsSync()) {
        return Image.file(
          File(path),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _fallbackLabel(),
        );
      }

      return Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _fallbackLabel(),
      );
    }

    // Layout: image container on the left, text + edit icon on the right
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
        children: [
          // Image container
          Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.imagePath != null
                  ? buildImage(item.imagePath!)
                  : _fallbackLabel(),
            ),
          ),

          const SizedBox(width: 12),

          // Right side: clothing item name (editable)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onEditName,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
