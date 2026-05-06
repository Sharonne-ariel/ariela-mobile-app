import 'package:flutter/material.dart';

import '../../app/petal_logo.dart';
import '../../app/theme.dart';

/// ARIELA splash screen.
///
/// First screen shown when the app launches. Displays the brand mark,
/// wordmark, and tagline. Will later transition to onboarding or home.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArielaTheme.surfaceBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Petal logo mark
                const PetalLogo(size: 96),

                const SizedBox(height: 32),

                // Wordmark
                Text(
                  'ariela',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: ArielaTheme.lavender900,
                        fontSize: 44,
                        letterSpacing: -0.88,
                      ),
                ),

                const SizedBox(height: 16),

                // Tagline (French — switch with localization later)
                Text(
                  'Comprendre ton corps, à chaque étape.',
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