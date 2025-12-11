// lib/widgets/add_item_dialog.dart (MODIFIED to include Dropdown)

import 'dart:io';

import 'package:flutter/material.dart';
import 'custom_button.dart';
// Image picker for camera capture
import 'package:image_picker/image_picker.dart';
// 🚨 NEW IMPORT: Access the central category data
import 'package:dresscode/utils/app_constants.dart';

// 🚨 CONVERTED to StatefulWidget to manage the dropdown selection state
class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  // Get the list of category names (e.g., ['Hat', 'Top', 'Bottom', 'Shoes'])
  final List<String> _categories = kCategoryOrder;

  // Hold the currently selected category (starts with the first in the list)
  late String _selectedCategory;
  // Controller for the new item name field
  late final TextEditingController _itemNameController;
  // Image picker and captured/uploaded files
  final ImagePicker _picker = ImagePicker();
  XFile? _capturedImage;
  XFile? _uploadedImage;

  @override
  void initState() {
    super.initState();
    // Initialize state with the first category or a fallback
    _selectedCategory = _categories.isNotEmpty ? _categories.first : 'Other';
    _itemNameController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        height: MediaQuery.of(context).size.height * 0.70,
        width: MediaQuery.of(context).size.width * 0.85,

        child: Column(
          children: <Widget>[
            // 1. Dialog Title
            const Text(
              'Add a Clothing Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),

            // 2. Photo Display Section (Expanded to fill available space)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Center(
                    child: (_capturedImage == null && _uploadedImage == null)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.photo_camera,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'No photo yet. \nUse CAPTURE or UPLOAD to add one.',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : (_capturedImage != null && _uploadedImage != null)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_capturedImage!.path),
                                    fit: BoxFit.cover,
                                    height: 180,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_uploadedImage!.path),
                                    fit: BoxFit.cover,
                                    height: 180,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File((_capturedImage ?? _uploadedImage)!.path),
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // NEW: Item name text field (before category selector)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),

            //  Category Dropdown Selector (Before the button row)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Clothing Category',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                value: _selectedCategory,
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: _categories.map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            // ROW 3
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // UPLOAD
                  Expanded(
                    child: CustomButton(
                      text: 'UPLOAD',
                      onPressed: (ctx) async {
                        try {
                          final XFile? photo = await _picker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 1920,
                            maxHeight: 1080,
                            imageQuality: 85,
                          );
                          if (photo != null) {
                            setState(() {
                              _uploadedImage = photo;
                            });
                          }
                        } catch (e) {
                          debugPrint('Gallery pick error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to pick photo'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  // TAKE PHOTO
                  Expanded(
                    child: CustomButton(
                      text: 'CAPTURE',
                      onPressed: (ctx) async {
                        try {
                          final XFile? photo = await _picker.pickImage(
                            source: ImageSource.camera,
                            maxWidth: 1920,
                            maxHeight: 1080,
                            imageQuality: 85,
                          );
                          if (photo != null) {
                            setState(() {
                              _capturedImage = photo;
                            });
                          }
                        } catch (e) {
                          debugPrint('Camera error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to capture photo'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            //ROW 4
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CANCEL Button
                  Expanded(
                    child: CustomButton(
                      text: 'CANCEL',
                      onPressed: (ctx) => Navigator.pop(ctx),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // SAVE Button (Primary action)
                  Expanded(
                    child: CustomButton(
                      text: 'SAVE',
                      onPressed: (ctx) {
                        debugPrint(
                          'Saving item to category: $_selectedCategory',
                        );
                        Navigator.pop(ctx);
                      },
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
