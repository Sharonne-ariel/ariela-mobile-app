import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';

enum Symptom {
  cramps,
  headache,
  fatigue,
  bloating,
  acne,
  tender,
  cravings,
  backPain,
  moodHappy,
  moodSad,
  moodAnxious,
  moodIrritable;

  String label(AppLocalizations l10n) => switch (this) {
        Symptom.cramps => l10n.symptomCramps,
        Symptom.headache => l10n.symptomHeadache,
        Symptom.fatigue => l10n.symptomFatigue,
        Symptom.bloating => l10n.symptomBloating,
        Symptom.acne => l10n.symptomAcne,
        Symptom.tender => l10n.symptomTender,
        Symptom.cravings => l10n.symptomCravings,
        Symptom.backPain => l10n.symptomBackPain,
        Symptom.moodHappy => l10n.symptomMoodHappy,
        Symptom.moodSad => l10n.symptomMoodSad,
        Symptom.moodAnxious => l10n.symptomMoodAnxious,
        Symptom.moodIrritable => l10n.symptomMoodIrritable,
      };

  IconData get icon => switch (this) {
        Symptom.cramps => Icons.bolt_outlined,
        Symptom.headache => Icons.psychology_outlined,
        Symptom.fatigue => Icons.battery_2_bar_outlined,
        Symptom.bloating => Icons.air_outlined,
        Symptom.acne => Icons.face_outlined,
        Symptom.tender => Icons.favorite_outline,
        Symptom.cravings => Icons.restaurant_outlined,
        Symptom.backPain => Icons.accessibility_new_outlined,
        Symptom.moodHappy => Icons.sentiment_very_satisfied_outlined,
        Symptom.moodSad => Icons.sentiment_dissatisfied_outlined,
        Symptom.moodAnxious => Icons.sentiment_neutral_outlined,
        Symptom.moodIrritable => Icons.mood_bad_outlined,
      };
}

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final Set<Symptom> _selected = {};

  void _toggle(Symptom s) {
    setState(() {
      if (_selected.contains(s)) {
        _selected.remove(s);
      } else {
        _selected.add(s);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ArielaTheme.surfaceBg,
      appBar: AppBar(
        backgroundColor: ArielaTheme.surfaceBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: ArielaTheme.textHeading),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.symptomsTitle,
                style: textTheme.headlineLarge?.copyWith(
                  color: ArielaTheme.lavender900,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.symptomsSubtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: ArielaTheme.textBody,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: Symptom.values.length,
                  itemBuilder: (context, index) {
                    final s = Symptom.values[index];
                    final isSelected = _selected.contains(s);
                    return _SymptomChip(
                      symptom: s,
                      isSelected: isSelected,
                      onTap: () => _toggle(s),
                      l10n: l10n,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ArielaButton(
                label: l10n.saveButton,
                icon: Icons.check_rounded,
                onPressed: _selected.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.symptomsSavedSnack),
                            backgroundColor: ArielaTheme.lavender600,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        Navigator.of(context).pop();
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

class _SymptomChip extends StatelessWidget {
  const _SymptomChip({
    required this.symptom,
    required this.isSelected,
    required this.onTap,
    required this.l10n,
  });

  final Symptom symptom;
  final bool isSelected;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? ArielaTheme.lavender50 : ArielaTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? ArielaTheme.lavender600
                : const Color(0xFFEAE7E1),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              symptom.icon,
              size: 28,
              color: isSelected
                  ? ArielaTheme.lavender600
                  : ArielaTheme.textBody,
            ),
            const SizedBox(height: 8),
            Text(
              symptom.label(l10n),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? ArielaTheme.lavender900
                    : ArielaTheme.textBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}