import 'package:flutter/material.dart';

import '../../app/petal_logo.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';
import 'goal_selection_screen.dart';

/// ARIELA welcome screen — the first interactive screen.
///
/// Shown after the splash transition. Welcomes the user and offers a single
/// primary CTA to begin the onboarding journey.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ArielaTheme.surfaceBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              const PetalLogo(size: 72),

              const SizedBox(height: 20),

              Text(
                l10n.appName,
                style: textTheme.displayLarge?.copyWith(
                  color: ArielaTheme.lavender900,
                  fontSize: 36,
                  letterSpacing: -0.72,
                ),
              ),

              const Spacer(flex: 2),

              Text(
                l10n.welcomeTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  color: ArielaTheme.lavender900,
                  fontSize: 26,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                l10n.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: ArielaTheme.textBody,
                  height: 1.55,
                ),
              ),

              const Spacer(flex: 3),

              ArielaButton(
                label: l10n.getStarted,
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const GoalSelectionScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}