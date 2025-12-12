import 'package:flutter/material.dart';

/// Helper to show snackbars above dialogs using Overlay
class SnackbarHelper {
  /// Shows a snackbar that appears above dialogs (higher z-index via Overlay)
  static void showSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 1),
  }) {
    final overlay = Overlay.of(context);
    final snackbarEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );

    overlay.insert(snackbarEntry);

    Future.delayed(duration, () {
      snackbarEntry.remove();
    });
  }
}
