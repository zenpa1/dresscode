class AppCategories {
  static const String hat = 'hat';
  static const String top = 'top';
  static const String bottom = 'bottom';
  static const String shoes = 'shoes';
}

const Map<String, List<String>> kMockCategories = {
  'Hat': ['Baseball Cap', 'Beanie', 'Sun Hat'],
  'Top': ['T-Shirt', 'Blouse', 'Sweater', 'Jacket'],
  'Bottom': ['Jeans', 'Shorts', 'Skirt', 'Dress Pants'],
  'Shoes': ['Sneakers', 'Boots', 'Sandals', 'Loafers'],
};

const List<String> kCategoryOrder = ['Hat', 'Top', 'Bottom', 'Shoes'];

//  OUTFIT DATA
List<Map<String, dynamic>> kMockOutfits = [
  {
    'name': 'Casual Weekend',
    'items': [
      kMockCategories['Top']![0], // 'T-Shirt'
      kMockCategories['Bottom']![0], // 'Jeans'
      kMockCategories['Shoes']![0], // 'Sneakers'
    ],
  },
  {
    'name': 'Cool Day Out',
    'items': [
      kMockCategories['Top']![2], // 'Sweater'
      kMockCategories['Bottom']![1], // 'Shorts'
      kMockCategories['Shoes']![3], // 'Loafers'
      kMockCategories['Hat']![1], // 'Beanie'
    ],
  },
  {
    'name': 'Summer Ready',
    'items': [
      kMockCategories['Top']![1], // 'Blouse'
      kMockCategories['Bottom']![2], // 'Skirt'
      kMockCategories['Shoes']![2], // 'Sandals'
      kMockCategories['Hat']![2], // 'Sun Hat'
    ],
  },
  {
    'name': 'Formal Look',
    'items': [
      kMockCategories['Top']![3], // 'Jacket'
      kMockCategories['Bottom']![3], // 'Dress Pants'
      kMockCategories['Shoes']![1], // 'Boots'
    ],
  },
];
