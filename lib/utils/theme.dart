import 'package:flutter/material.dart';

class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const lightOrange = Color(0xFFF0EEEC);
  static const dark = Color(0xFF1A1416);
  static const grey = Color(0xFF8B8889);
  static const softGrey = Color(0xFFF6F6F6);
}

class AppTheme {
  static ThemeData light = ThemeData(
    fontFamily: 'Futura',

    scaffoldBackgroundColor: AppColors.white,
    canvasColor: AppColors.white,

    colorScheme: const ColorScheme.light(
      surface:
          AppColors.lightOrange, // For cards, containers, and surface elements
      primary: AppColors.dark, // Primary actions (buttons, active elements)
      secondary: AppColors.grey, // Disabled buttons or muted UI
      tertiary: AppColors
          .softGrey, // Extra subtle UI color (dividers, faint backgrounds)
      outlineVariant: AppColors.softGrey,
      onPrimary: AppColors.white, // Text on primary (dark background) → white
      onSurface: AppColors.dark, // Text on surfaces (lightOrange background)
    ),
  );
}
