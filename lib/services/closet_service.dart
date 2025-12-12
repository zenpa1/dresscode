import 'dart:io';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/clothing_item.dart';
import 'file_storage_service.dart';

/// Service for managing clothing items in the local Hive box and their
/// corresponding image files on disk.
class ClosetService {
  final FileStorageService fileStorageService;
  final Uuid _uuid = const Uuid();

  late Box<ClothingItem> _box;

  ClosetService({required this.fileStorageService});

  /// Initialize the service and open the Hive box named 'closet_box'.
  Future<void> init() async {
    _box = await Hive.openBox<ClothingItem>('closet_box');
  }

  /// Save a new clothing item. Copies the provided [imageFile] to the app
  /// documents directory, creates a `ClothingItem` with a new id and current
  /// timestamp, stores it in Hive, and returns the created item.
  Future<ClothingItem> saveNewItem(
    File imageFile,
    String name,
    String category,
  ) async {
    // Save image to disk
    final savedPath = await fileStorageService.saveImageToDisk(imageFile);

    // Create ClothingItem
    final id = _uuid.v4();
    final item = ClothingItem(
      id: id,
      name: name,
      imagePath: savedPath,
      category: category,
      createdAt: DateTime.now(),
    );

    // Persist to Hive
    await _box.put(id, item);
    return item;
  }

  /// Delete the provided [item]: removes its image file from disk and deletes
  /// the record from Hive.
  Future<void> deleteItem(ClothingItem item) async {
    try {
      await fileStorageService.deleteImageFromDisk(item.imagePath);
    } catch (_) {
      // ignore errors from file deletion
    }

    // Remove from Hive
    await item.delete();
  }

  /// Returns the closet organized into categories and sorted by `createdAt`
  /// descending (newest first).
  ClosetData getOrganizedCloset() {
    final values = _box.values.toList();

    List<ClothingItem> sortedWhere(bool Function(ClothingItem) fn) {
      final list = values.where(fn).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    }

    final hats = sortedWhere((i) => i.category == 'hat');
    final tops = sortedWhere((i) => i.category == 'top');
    final bottoms = sortedWhere((i) => i.category == 'bottom');
    final shoes = sortedWhere((i) => i.category == 'shoes');

    return ClosetData(hats: hats, tops: tops, bottoms: bottoms, shoes: shoes);
  }
}

/// Simple DTO representing grouped closet lists.
class ClosetData {
  final List<ClothingItem> hats;
  final List<ClothingItem> tops;
  final List<ClothingItem> bottoms;
  final List<ClothingItem> shoes;

  ClosetData({
    required this.hats,
    required this.tops,
    required this.bottoms,
    required this.shoes,
  });
}
