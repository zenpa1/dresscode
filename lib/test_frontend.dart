import 'package:flutter/material.dart';
import 'package:dresscode/utils/theme.dart';

void main() {
  runApp(const TestCanvasApp());
}

class TestCanvasApp extends StatelessWidget {
  const TestCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.light, home: const TestCanvas());
  }
}

class TestCanvas extends StatelessWidget {
  const TestCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👇 put ANY widget you want to test:
      body: Center(
        child: Text(
          "Hello Futura!",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
