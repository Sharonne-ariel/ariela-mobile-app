import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/petal_logo.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../onboarding/welcome_screen.dart';

/// ARIELA splash screen.
///
/// First screen shown when the app launches. Displays the brand mark,
/// wordmark, and tagline, then transitions to [WelcomeScreen] after a
/// brief delay.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // After 2 seconds, navigate to the welcome screen.
    // Using pushReplacement so the user can't go "back" to the splash.
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: ArielaTheme.surfaceBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PetalLogo(size: 96),

                const SizedBox(height: 32),

                Text(
                  l10n.appName,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: ArielaTheme.lavender900,
                        fontSize: 44,
                        letterSpacing: -0.88,
                      ),
                ),

                const SizedBox(height: 16),

                Text(
                  l10n.tagline,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ArielaTheme.textBody,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}