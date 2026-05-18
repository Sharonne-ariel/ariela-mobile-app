import 'package:flutter/material.dart';
import '../first_period/first_period_screen.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';
import 'user_goal.dart';
import '../cycle/home_screen.dart';
import 'coming_soon_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  UserGoal? _selected;

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.goalTitle,
                style: textTheme.headlineLarge?.copyWith(
                  color: ArielaTheme.lavender900,
                  fontSize: 26,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.goalSubtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: ArielaTheme.textBody,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: UserGoal.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final goal = UserGoal.values[index];
                    final isSelected = _selected == goal;
                    return _GoalCard(
                      goal: goal,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selected = goal),
                      l10n: l10n,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ArielaButton(
                label: l10n.continueButton,
                icon: Icons.arrow_forward_rounded,
                onPressed: _selected == null
                    ? null
                    : () {
                        if (_selected == UserGoal.cycle) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        } else if (_selected == UserGoal.firstPeriod) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const FirstPeriodScreen(),
                            ),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ComingSoonScreen(goal: _selected!),
                            ),
                          );
                        }
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

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
    required this.l10n,
  });

  final UserGoal goal;
  final bool isSelected;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ArielaTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? ArielaTheme.lavender600
                : const Color(0xFFEAE7E1),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: goal.iconBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(goal.icon, size: 18, color: goal.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.label(l10n),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? ArielaTheme.lavender900
                          : ArielaTheme.textHeading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    goal.subtitle(l10n),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ArielaTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: ArielaTheme.lavender600,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
          ],
        ),
      ),
    );
  }
}