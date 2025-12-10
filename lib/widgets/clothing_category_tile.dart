import 'package:flutter/material.dart';
import 'package:dresscode/utils/app_constants.dart';

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

                return Container(
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
