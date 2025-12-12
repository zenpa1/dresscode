// lib/widgets/add_item_dialog.dart (Implements image picking and Hive saving)

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:hive/hive.dart';
import 'custom_button.dart';
import 'package:dresscode/utils/app_constants.dart';
import 'package:dresscode/models/clothing_item.dart' as models;
import 'package:dresscode/services/file_storage_service.dart';
import 'package:dresscode/utils/snackbar_helper.dart';

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

  // Hold the selected image file and path
  File? _selectedImage;
  String? _savedImagePath;

  // Text controller for item name
  late TextEditingController _nameController;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize state with the first category or a fallback
    _selectedCategory = _categories.isNotEmpty ? _categories.first : 'Other';
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        // Optionally crop the image
        await _cropImage();
      }
    } catch (e) {
      if (!mounted) return;
      SnackbarHelper.showSnackbar(
        context: context,
        message: 'Error picking image: $e',
      );
    }
  }

  /// Capture an image using the camera
  Future<void> _captureImageWithCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        // Optionally crop the image
        await _cropImage();
      }
    } catch (e) {
      if (!mounted) return;
      SnackbarHelper.showSnackbar(
        context: context,
        message: 'Error capturing image: $e',
      );
    }
  }

  /// Crop the selected image
  Future<void> _cropImage() async {
    if (_selectedImage == null) return;

    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _selectedImage!.path,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: false),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _selectedImage = File(croppedFile.path);
        });
      }
    } catch (e) {
      // Silently ignore crop errors - user can proceed with original image
      debugPrint('Image crop failed (non-fatal): $e');
    }
  }

  /// Save the clothing item to Hive
  Future<void> _saveItemToHive() async {
    if (_nameController.text.trim().isEmpty) {
      SnackbarHelper.showSnackbar(
        context: context,
        message: 'Please enter an item name',
      );
      return;
    }

    if (_selectedImage == null && _savedImagePath == null) {
      SnackbarHelper.showSnackbar(
        context: context,
        message: 'Please select or capture an image',
      );
      return;
    }

    try {
      // If we have a new image, save it to storage
      String imagePath = _savedImagePath ?? '';
      if (_selectedImage != null) {
        final fileStorageService = FileStorageService();
        imagePath = await fileStorageService.saveImageToDisk(_selectedImage!);
        debugPrint('Image saved to: $imagePath');
      }

      // Create and save the clothing item
      final item = models.ClothingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        imagePath: imagePath,
        category: _selectedCategory,
        createdAt: DateTime.now(),
      );

      debugPrint(
        'Creating ClothingItem: ${item.id}, ${item.name}, ${item.category}',
      );

      // Get the closet box and save the item
      try {
        final closetBox = Hive.box<models.ClothingItem>('closet_box');
        debugPrint('closet_box opened successfully');

        await closetBox.put(item.id, item);
        debugPrint('Item saved to Hive: ${item.id}');
      } catch (boxError) {
        debugPrint('Error accessing closet_box: $boxError');
        throw Exception('Failed to access closet database: $boxError');
      }

      if (!mounted) return;

      // Show success message and close dialog
      SnackbarHelper.showSnackbar(
        context: context,
        message: '${item.name} added to $_selectedCategory',
        duration: const Duration(seconds: 2),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error in _saveItemToHive: $e');
      if (!mounted) return;
      SnackbarHelper.showSnackbar(
        context: context,
        message: 'Error saving item: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        height: MediaQuery.of(context).size.height * 0.85,
        width: MediaQuery.of(context).size.width * 0.85,

        child: Column(
          children: <Widget>[
            // 1. Dialog Title
            const Text(
              'Add a Clothing Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),

            // 2. Photo Display Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Select or capture a photo',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 3. Item Name Input
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g., Red Sweater',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // 4. Category Dropdown Selector
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Clothing Category',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                initialValue: _selectedCategory,
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

            // 5. Image Source Buttons (UPLOAD and CAPTURE)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // UPLOAD (Gallery)
                  Expanded(
                    child: CustomButton(
                      text: 'GALLERY',
                      onPressed: (ctx) => _pickImageFromGallery(),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // TAKE PHOTO (Camera)
                  Expanded(
                    child: CustomButton(
                      text: 'CAMERA',
                      onPressed: (ctx) => _captureImageWithCamera(),
                    ),
                  ),
                ],
              ),
            ),

            // 6. Action Buttons (CANCEL and SAVE)
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
                      backgroundColor: Colors.grey.shade300,
                      textColor: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // SAVE Button (Primary action)
                  Expanded(
                    child: CustomButton(
                      text: 'SAVE',
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      onPressed: (ctx) => _saveItemToHive(),
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
