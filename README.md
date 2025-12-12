# dresscode

A local-first Flutter application for managing your digital wardrobe. Organize clothing items by category (Hat, Top, Bottom, Shoes), create and save outfit combinations, and never wonder what to wear again.

## Features

- **Clothing Management**
  - Add items with photos from camera or gallery
  - Organize items by category (Hat, Top, Bottom, Shoes)
  - View and manage your complete closet
  - Delete items with confirmation
  - Real-time UI updates using Hive ValueListenableBuilder

- **Outfit Creation & Management**
  - Create outfits by selecting items from each category using interactive carousels
  - Save outfits with custom names
  - View saved outfits with thumbnail previews
  - Edit outfit names and item labels
  - Delete outfits with confirmation
  - Search outfits by name
  - Edit outfit by returning to closet with pre-selected items

- **Image Handling**
  - Capture photos using device camera
  - Pick images from gallery
  - Optional image cropping (via image_cropper)
  - Dual-mode display: local file storage or bundled assets
  - Automatic file management and cleanup on deletion

- **Local-First Data Persistence**
  - All data stored locally using Hive NoSQL database
  - No cloud dependency or internet required
  - Fast, encrypted storage
  - Reactive UI updates via Hive listenable boxes

## Tech Stack

- **Framework**: Flutter 3.x with Dart 3.10+
- **Database**: Hive (NoSQL key-value store)
- **State Management**: Hive ValueListenableBuilder + Flutter setState
- **Image Handling**: image_picker, image_cropper
- **Utilities**: uuid, path_provider, build_runner
- **Code Generation**: hive_generator for adapter creation

## Architecture

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── clothing_item.dart   # Hive model for clothing items
│   └── outfit.dart          # Hive model for outfits
├── screens/
│   ├── splash_screen.dart   # Hive initialization splash
│   ├── home_closet.dart     # Main closet with carousels
│   ├── outfits.dart         # Outfit listing and search
│   └── outfit_detail.dart   # Outfit view/edit
├── services/
│   ├── closet_service.dart  # Closet business logic
│   ├── file_storage_service.dart  # Image file management
│   └── outfit_service.dart  # Outfit business logic
├── widgets/
│   ├── clothing_card_row.dart      # Carousel display
│   ├── add_item_dialog.dart        # Image picker + save
│   ├── save_outfit_dialog.dart     # Outfit confirmation
│   ├── outfit_container.dart       # Outfit list card
│   ├── clothing_category_tile.dart # Item grid/deletion
│   └── ...
└── utils/
    ├── app_constants.dart   # Constants and category definitions
    └── theme.dart           # App styling
```

### Data Models

**ClothingItem** (Hive typeId: 0)
- `id`: Unique identifier (UUID)
- `name`: Item display name
- `imagePath`: File path or asset path
- `category`: Hat, Top, Bottom, or Shoes
- `createdAt`: Timestamp

**Outfit** (Hive typeId: 1)
- `id`: Unique identifier (UUID)
- `name`: Outfit display name (mutable)
- `hatId`: Reference to clothing item (nullable)
- `topId`: Reference to clothing item (nullable)
- `bottomId`: Reference to clothing item (nullable)
- `shoesId`: Reference to clothing item (nullable)
- `savedAt`: Outfit creation timestamp

## Installation & Setup

### Prerequisites
- Flutter SDK 3.x or higher
- Dart 3.10+
- Android SDK (for Android builds) or Xcode (for iOS builds)

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dresscode
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build
   ```
   (Rebuild if models change: `flutter pub run build_runner build --delete-conflicting-outputs`)

4. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Adding Items to Your Closet

1. On the home closet screen, tap "ADD AN ITEM" button
2. Choose a category from the dropdown
3. Enter an item name
4. Tap **GALLERY** to pick from photos or **CAMERA** to take a new photo
5. Optionally crop the image
6. Tap **SAVE**

### Creating an Outfit

1. From the home closet screen, rotate the carousels to select:
   - A hat
   - A top
   - A bottom
   - Shoes
2. Tap **SAVE OUTFIT** button
3. Enter an outfit name (defaults to "My New Outfit")
4. Review the selected items in the preview
5. Tap **CONFIRM** to save

### Viewing & Editing Outfits

1. Navigate to **OUTFITS** from the home screen
2. Search by outfit name if needed
3. Tap an outfit to view details
4. **Edit Outfit Name**: Tap the pencil icon next to the title
5. **Edit Item Name**: Tap the pencil icon next to any item
6. **Edit Items**: Tap **EDIT** to return to closet with pre-selected items
7. **Delete Outfit**: Tap **DELETE** and confirm

### Managing Closet Items

1. Tap **ADD AN ITEM** button
2. Expand any category to see your items
3. Tap an item to delete it (with confirmation)

## Key Features Deep Dive

### Image Handling
- **File Detection**: Intelligently detects absolute paths (`/data/`, `/storage/`, Windows paths) vs asset paths
- **Dual-Mode Loading**: Uses `Image.file()` for saved photos, `Image.asset()` for bundled images
- **Error Fallback**: Shows item name if image fails to load
- **Cleanup**: Removes image files from disk when items are deleted

### Real-Time Updates
- Hive listenable boxes trigger UI rebuilds automatically
- ValueListenableBuilder wraps carousels and outfit lists
- Deleted items disappear immediately from grid
- New items appear in carousels without closing/reopening

### Data Synchronization
- Carousel item selection cached in `_currentCategoryItems` map
- Prevents mismatch between displayed items and saved selections
- Accurate outfit saves even with dynamic item lists

### Edit Persistence
- Outfit name edits saved directly to Hive
- Item label edits update outfit record
- All changes persist across app restarts
- Success/error messages provide feedback

## Development

### Adding Hive Models

1. Create a new model class with `@HiveType(typeId: X)` annotations
2. Add `@HiveField(index)` to each field
3. Run `flutter pub run build_runner build`
4. Register adapter in app initialization

### Modifying Existing Models

1. Update the model class
2. Increment the `typeId` if adding new classes
3. Regenerate with build_runner
4. Test data migration (Hive handles backward compatibility)

### UI State Management

- **Local State**: StatefulWidget + `setState()` for dialogs and forms
- **Persistent State**: Hive boxes with ValueListenableBuilder
- **Navigation**: Named routes with MaterialPageRoute

## Known Limitations

- Item name customization only affects display in outfit details (does not rename the item in closet)
- No outfit duplication feature
- No multi-select for batch deletion
- No cloud sync or backup
- Android-first development (iOS, Web, Linux, macOS builds untested)

## Future Enhancements

- [ ] Weather-based outfit suggestions
- [ ] Outfit usage tracking (wear count, last worn)
- [ ] Color and style tags for items
- [ ] Outfit history and favoriting
- [ ] Cloud backup and sync
- [ ] Share outfits with others
- [ ] Outfit templates and recommendations
- [ ] Laundry tracking reminders

## Troubleshooting

### Images not showing in outfits
- Ensure FileStorageService paths are correct
- Check that saved image files still exist on device
- Clear app data and re-add items: Settings → Apps → Dresscode → Storage → Clear Data

### Hive box errors
- Delete app and reinstall: `flutter clean && flutter pub get && flutter run`
- Check that build_runner generated adapters successfully
- Verify typeIds are unique across all models

### Build failures
- Run `flutter clean`
- Delete `.dart_tool` directory
- Run `flutter pub get`
- Run `flutter pub run build_runner build --delete-conflicting-outputs`

Developed by zenpa1 and ian
**Last Updated**: December 2025  
**Created with**: Flutter & Dart
