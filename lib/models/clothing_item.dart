import 'package:hive/hive.dart';

part 'clothing_item.g.dart';

@HiveType(typeId: 0)
class ClothingItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imagePath;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime createdAt;

  ClothingItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.createdAt,
  });
}
