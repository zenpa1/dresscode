class ClothingItem {
  final String id;
  final String name;
  final String imagePath; // Path to the image file in assets
  final String category;

  const ClothingItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
  });
}

class AppCategories {
  static const String hat = 'Hat';
  static const String top = 'Top';
  static const String bottom = 'Bottom';
  static const String shoes = 'Shoes';
}

//  Map now holds a List of ClothingItem objects
const Map<String, List<ClothingItem>> kMockCategories = {
  AppCategories.hat: [
    ClothingItem(
      id: 'h1',
      name: 'Russian Hat',
      imagePath: 'assets/images/hat_1.jpg',
      category: AppCategories.hat,
    ),
    ClothingItem(
      id: 'h2',
      name: 'Cap 1',
      imagePath: 'assets/images/hat_2.jpg',
      category: AppCategories.hat,
    ),
    ClothingItem(
      id: 'h3',
      name: 'Cap 2',
      imagePath: 'assets/images/hat_3.jpg',
      category: AppCategories.hat,
    ),
    ClothingItem(
      id: 'h4',
      name: 'Sun Hat',
      imagePath: 'assets/images/hat_4.png',
      category: AppCategories.hat,
    ),
  ],
  AppCategories.top: [
    ClothingItem(
      id: 't1',
      name: 'Rustic',
      imagePath: 'assets/images/top_1.jpg',
      category: AppCategories.top,
    ),
    ClothingItem(
      id: 't2',
      name: 'Plad',
      imagePath: 'assets/images/top_2.jpg',
      category: AppCategories.top,
    ),
    ClothingItem(
      id: 't3',
      name: 'Cool',
      imagePath: 'assets/images/top_3.jpg',
      category: AppCategories.top,
    ),
    ClothingItem(
      id: 't4',
      name: 'Scott',
      imagePath: 'assets/images/top_4.jpg',
      category: AppCategories.top,
    ),
    ClothingItem(
      id: 't5',
      name: 'Black',
      imagePath: 'assets/images/top_5.jpg',
      category: AppCategories.top,
    ),
  ],
  AppCategories.bottom: [
    ClothingItem(
      id: 'b1',
      name: 'Jeans',
      imagePath: 'assets/images/bottom_1.jpg',
      category: AppCategories.bottom,
    ),
    ClothingItem(
      id: 'b2',
      name: 'Brown Pants',
      imagePath: 'assets/images/bottom_2.jpg',
      category: AppCategories.bottom,
    ),
    ClothingItem(
      id: 'b3',
      name: 'Shorts',
      imagePath: 'assets/images/bottom_3.jpg',
      category: AppCategories.bottom,
    ),
    ClothingItem(
      id: 'b4',
      name: 'Shibuya',
      imagePath: 'assets/images/bottom_4.jpg',
      category: AppCategories.bottom,
    ),
  ],
  AppCategories.shoes: [
    ClothingItem(
      id: 's1',
      name: 'Converse',
      imagePath: 'assets/images/shoes_1.jpg',
      category: AppCategories.shoes,
    ),
    ClothingItem(
      id: 's2',
      name: 'Boots',
      imagePath: 'assets/images/shoes_2.jpg',
      category: AppCategories.shoes,
    ),
    ClothingItem(
      id: 's3',
      name: 'Long Boots',
      imagePath: 'assets/images/shoes_3.jpg',
      category: AppCategories.shoes,
    ),
  ],
};

const List<String> kCategoryOrder = [
  AppCategories.hat,
  AppCategories.top,
  AppCategories.bottom,
  AppCategories.shoes,
];

List<Map<String, dynamic>> kMockOutfits = [];
