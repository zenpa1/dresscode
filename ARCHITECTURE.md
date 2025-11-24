# Dresscode: Architecture & Data Contract

## 🧠 Master Context

**Project Name:** dresscode
**Type:** Local-First Flutter Application
**Purpose:** Digital closet organizer and outfit planner.
**Tech Stack:** - **Framework:** Flutter

- **Database:** Hive (NoSQL, Key-Value)
- **File Storage:** `path_provider` (Local ApplicationDocumentsDirectory)
- **IDs:** `uuid` package
- **Image Handling:** `image_picker`, `image_cropper`

## 🧱 Key Constraints

1.  **No Backend:** There is no server, no Firebase, and no API. All data is local.
2.  **Strict Categories:** Items must belong to one of 4 categories: `hat`, `top`, `bottom`, `shoes`.
3.  **Image Storage:** Images are saved to the physical disk (AppDocsDir). The Database only stores the **File Path**.
4.  **Ghost Items:** If an item is deleted from the `closet_box`, any `Outfit` referencing it must handle the missing image gracefully (show a placeholder, do not crash).
5.  **Separation of Concerns:** - `screens/` handle UI.
    - `services/` handle Logic & Database calls.
    - `models/` handle Data Structure.

---

## 📚 Data Dictionary

### Entity 1: `ClothingItem`

- **Hive TypeId:** `0`
- **Box Name:** `'closet_box'`
- **Description:** Represents a single physical piece of clothing.

| Field       | Type       | HiveField | Description                                    |
| :---------- | :--------- | :-------- | :--------------------------------------------- |
| `id`        | `String`   | `0`       | Unique UUID. Primary Key.                      |
| `imagePath` | `String`   | `1`       | Absolute local path to the cropped image file. |
| `category`  | `String`   | `2`       | Strictly: 'hat', 'top', 'bottom', or 'shoes'.  |
| `createdAt` | `DateTime` | `3`       | Used for sorting the Gallery (Newest First).   |

### Entity 2: `Outfit`

- **Hive TypeId:** `1`
- **Box Name:** `'outfits_box'`
- **Description:** A saved combination of items (Foreign Keys).

| Field      | Type       | HiveField | Description                                       |
| :--------- | :--------- | :-------- | :------------------------------------------------ |
| `id`       | `String`   | `0`       | Unique UUID. Primary Key.                         |
| `name`     | `String?`  | `1`       | User-defined name (e.g., "Date Night"). Nullable. |
| `hatId`    | `String?`  | `2`       | ID of the ClothingItem. Nullable.                 |
| `topId`    | `String?`  | `3`       | ID of the ClothingItem. Nullable.                 |
| `bottomId` | `String?`  | `4`       | ID of the ClothingItem. Nullable.                 |
| `shoesId`  | `String?`  | `5`       | ID of the ClothingItem. Nullable.                 |
| `savedAt`  | `DateTime` | `6`       | Used for sorting the Outfit List (Newest First).  |

---

## ⚙️ App Constants

Located in `lib/utils/app_constants.dart`.

```dart
class AppCategories {
  static const String hat = 'hat';
  static const String top = 'top';
  static const String bottom = 'bottom';
  static const String shoes = 'shoes';
}
```
