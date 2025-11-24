import 'dart:math';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/outfit.dart';
import 'closet_service.dart';

/// Service for managing saved outfits (Hive box 'outfits_box').
class OutfitService {
  final Uuid _uuid = const Uuid();
  late Box<Outfit> _box;

  /// Initialize and open the `outfits_box`.
  Future<void> init() async {
    _box = await Hive.openBox<Outfit>('outfits_box');
  }

  /// Save a new outfit with optional slot IDs and optional name.
  /// Returns the created `Outfit`.
  Future<Outfit> saveOutfit({
    String? hatId,
    String? topId,
    String? bottomId,
    String? shoesId,
    String? name,
  }) async {
    final id = _uuid.v4();
    final outfit = Outfit(
      id: id,
      name: name,
      hatId: hatId,
      topId: topId,
      bottomId: bottomId,
      shoesId: shoesId,
      savedAt: DateTime.now(),
    );

    await _box.put(id, outfit);
    return outfit;
  }

  /// Update an existing outfit. Because `Outfit` is immutable (fields are
  /// final), this replaces the stored object with a new instance that keeps
  /// the same `id` and `savedAt` unless overridden.
  Future<Outfit> updateOutfit(
    Outfit outfit, {
    String? name,
    String? hatId,
    String? topId,
    String? bottomId,
    String? shoesId,
  }) async {
    final updated = Outfit(
      id: outfit.id,
      name: name ?? outfit.name,
      hatId: hatId ?? outfit.hatId,
      topId: topId ?? outfit.topId,
      bottomId: bottomId ?? outfit.bottomId,
      shoesId: shoesId ?? outfit.shoesId,
      savedAt: outfit.savedAt,
    );

    await _box.put(outfit.id, updated);
    return updated;
  }

  /// Delete the outfit with the given [id] from the box.
  Future<void> deleteOutfit(String id) async {
    await _box.delete(id);
  }

  /// Search outfits by `name` case-insensitively. Returns matching outfits.
  List<Outfit> searchOutfits(String query) {
    if (query.trim().isEmpty) return _box.values.toList();

    final q = query.toLowerCase();
    return _box.values
        .where((o) => (o.name ?? '').toLowerCase().contains(q))
        .toList();
  }

  /// Return random indices for each slot based on available lists in
  /// [closetData]. If a list is empty, index will be 0.
  Map<String, int> randomizeOutfit(ClosetData closetData) {
    final rng = Random();

    int randIndex(List list) {
      if (list.isEmpty) return 0;
      return rng.nextInt(list.length);
    }

    return {
      'hat': randIndex(closetData.hats),
      'top': randIndex(closetData.tops),
      'bottom': randIndex(closetData.bottoms),
      'shoes': randIndex(closetData.shoes),
    };
  }
}
