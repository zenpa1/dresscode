import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Service responsible for saving and deleting image files on disk.
class FileStorageService {
  final Uuid _uuid = const Uuid();

  /// Saves [sourceFile] into the application's documents directory using
  /// a UUID-based filename. Returns the saved file's absolute path.
  Future<String> saveImageToDisk(File sourceFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final ext = _extensionFromPath(sourceFile.path);
    final filename = '${_uuid.v4()}.$ext';
    final newPath = '${appDir.path}${Platform.pathSeparator}$filename';

    final saved = await sourceFile.copy(newPath);
    return saved.path;
  }

  /// Deletes the file at [path] if it exists. Silently returns if the file
  /// does not exist or an error occurs.
  Future<void> deleteImageFromDisk(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Intentionally ignore errors here — caller can handle logging if desired.
    }
  }

  String _extensionFromPath(String path) {
    final idx = path.lastIndexOf('.');
    if (idx == -1 || idx == path.length - 1) return 'jpg';
    return path.substring(idx + 1);
  }
}
