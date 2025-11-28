import 'package:flutter/material.dart';
// NOTE: Ensure this path is correct for where you place your theme file.
import 'package:dresscode/utils/theme.dart';
// To use AppColors.dark and AppColors.white, we need to import AppColors,
// which is usually defined in the same file as AppTheme.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      // Apply the custom theme defined in the imported file
      theme: AppTheme.light,
      // Set TestPage as the initial screen the app displays
      home: const TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

// 1. Add TickerProviderStateMixin for the AnimationController
class _TestPageState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  // We need a second animation for sequential fading
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    // 2. Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                width: 150,
                height: 150,
                color: AppColors.lightOrange,
                child: const Icon(Icons.star, size: 50, color: AppColors.dark),
              ),
            ),
            FadeTransition(
              opacity: _textOpacityAnimation,
              child: const Text(
                'DRESSCODE',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
