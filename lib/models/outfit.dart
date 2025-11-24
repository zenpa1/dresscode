import 'package:hive/hive.dart';

part 'outfit.g.dart';

@HiveType(typeId: 1)
class Outfit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? hatId;

  @HiveField(3)
  final String? topId;

  @HiveField(4)
  final String? bottomId;

  @HiveField(5)
  final String? shoesId;

  @HiveField(6)
  final DateTime savedAt;

  Outfit({
    required this.id,
    this.name,
    this.hatId,
    this.topId,
    this.bottomId,
    this.shoesId,
    required this.savedAt,
  });

  /// Returns true if the `hatId` is non-null and exists in the provided
  /// `closetBox` (avoids crashing when the referenced item was deleted).
  bool isHatValid(Box closetBox) {
    if (hatId == null) return false;
    return closetBox.containsKey(hatId);
  }

  bool isTopValid(Box closetBox) {
    if (topId == null) return false;
    return closetBox.containsKey(topId);
  }

  bool isBottomValid(Box closetBox) {
    if (bottomId == null) return false;
    return closetBox.containsKey(bottomId);
  }

  bool isShoesValid(Box closetBox) {
    if (shoesId == null) return false;
    return closetBox.containsKey(shoesId);
  }
}
