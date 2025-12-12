import 'dart:io';

import 'package:flutter/material.dart';

class OutfitClothingCard extends StatelessWidget {
  final String label;
  final String? imagePath;
  final double itemSize;

  const OutfitClothingCard({
    super.key,
    required this.label,
    this.imagePath,
    this.itemSize = 90.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildImage(String path) {
      final isFilePath =
          path.startsWith('/') ||
          path.contains(RegExp(r'^[A-Za-z]:\\')) ||
          path.contains('/data/') ||
          path.contains('app_flutter');

      if (isFilePath && File(path).existsSync()) {
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _fallbackLabel(),
        );
      }

      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackLabel(),
      );
    }

    return Container(
      width: itemSize,
      height: itemSize,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imagePath != null ? buildImage(imagePath!) : _fallbackLabel(),
      ),
    );
  }

  Widget _fallbackLabel() {
    return Container(
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black54, fontSize: 10),
      ),
    );
  }
}
