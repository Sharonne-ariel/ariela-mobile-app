import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  // Ensure Flutter bindings are initialized before any platform calls.
  WidgetsFlutterBinding.ensureInitialized();

  // Lock app to portrait orientation only.
  // ARIELA is designed for portrait use; landscape would break layouts.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set system UI style: dark icons on light background.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: ArielaTheme.surfaceBg,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ArielaApp());
}

/// Root widget of the ARIELA application.
class ArielaApp extends StatelessWidget {
  const ArielaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARIELA',
      debugShowCheckedModeBanner: false,
      theme: ArielaTheme.light,
      home: const SplashScreen(),
    );
  }
}