import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dresscode/models/clothing_item.dart'; // Assumed model file
import 'package:dresscode/models/outfit.dart'; // Assumed model file
import 'package:dresscode/utils/theme.dart'; // Assumed theme file
import 'package:dresscode/screens/home_closet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters. Boxes will be opened in the
  // Splash Screen.
  await Hive.initFlutter();
  Hive.registerAdapter(ClothingItemAdapter());
  Hive.registerAdapter(OutfitAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dresscode',
      theme: AppTheme.light, // Assumed AppTheme is defined
      // Route setup: SplashScreen will open boxes and then navigate to Home.
      initialRoute: '/',
      routes: {
        // Route '/' points to your animated splash screen
        '/': (_) => const SplashScreen(),
      },
    );
  }
}

/// Animated and functional splash screen. It manages the fade-in animation

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // 3-second total duration
    );

    // Animation for box
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut), // 0% to 50%
      ),
    );

    // Animation for text
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeInOut), // 40% to 90%
      ),
    );

    // 2. Start Animation and Listen for Completion to Trigger Initialization
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Start app initialization only AFTER the animation finishes
        _initializeApp();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Open boxes here (we registered adapters in main()).
      await Hive.openBox<ClothingItem>('closet_box');
      await Hive.openBox<Outfit>('outfits_box');

      // After initialization, navigate to home.
      if (!mounted) return;

      // 2. REPLACE PlaceholderHome with DigitalClosetScreen
      Navigator.pushReplacement(
        context,
        // The DigitalClosetScreen is the main Widget from your home_closet.dart
        MaterialPageRoute(builder: (_) => const DigitalClosetScreen()),
      );
    } catch (e) {
      //error
    }
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
            // FadeTransition for logo image
            FadeTransition(
              opacity: _opacityAnimation,
              child: Image.asset(
                'assets/logo/dresscode_logo_transparent.png',
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            // FadeTransition for text
            FadeTransition(
              opacity: _textOpacityAnimation,
              child: const Text('dresscode', style: TextStyle(fontSize: 30)),
            ),
          ],
        ),
      ),
    );
  }
}
