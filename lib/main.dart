import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/theme.dart';
import 'features/splash/splash_screen.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Lock portrait orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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

/// Convenience accessor for the Supabase client.
final supabase = Supabase.instance.client;

class ArielaApp extends StatelessWidget {
  const ArielaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARIELA',
      debugShowCheckedModeBanner: false,
      theme: ArielaTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashScreen(),
    );
  }
}