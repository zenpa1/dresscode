import 'package:flutter/material.dart';
import 'package:dresscode/utils/app_constants.dart';
import 'package:dresscode/widgets/custom_button.dart';

class ClothingCategoryTile extends StatefulWidget {
  final String categoryName;
  final List<ClothingItem> availableItems;

  const ClothingCategoryTile({
    super.key,
    required this.categoryName,
    required this.availableItems,
  });

  @override
  State<ClothingCategoryTile> createState() => _ClothingCategoryTileState();
}

class _ClothingCategoryTileState extends State<ClothingCategoryTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.categoryName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),

        // --- Collapsible Content (The Grid View) ---
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox(height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: widget.availableItems.length,
              itemBuilder: (context, index) {
                final item = widget.availableItems[index];

                return GestureDetector(
                  onTap: () async {
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
                                'Delete Clothing Item',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Are you sure you want to delete this clothing item?',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Delete Item',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Show the item's image
                              Container(
                                width: 120,
                                height: 120,
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item.imagePath,
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, st) => Center(
                                      child: Text(
                                        item.name,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Show the item's name
                              Text(
                                item.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
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
                                      backgroundColor: Colors.red.shade700,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          content: Text('Outfit deleted'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.imagePath, // Use the imagePath from the data model
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(item.name, textAlign: TextAlign.center),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
