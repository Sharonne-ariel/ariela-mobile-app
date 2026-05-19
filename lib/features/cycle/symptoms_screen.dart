import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';
import '../notes/notes_repository.dart';
import 'symptoms_repository.dart';

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
  /// symptom → intensity (1=mild, 3=moderate, 5=strong)
  late Map<Symptom, int> _selected;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _selected = {
      for (final log in SymptomsRepository.instance.getForDate(DateTime.now()))
        log.symptom: log.intensity,
    };
    _noteController = TextEditingController(
      text: NotesRepository.instance.getForDate(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _toggle(Symptom s) {
    setState(() {
      if (_selected.containsKey(s)) {
        _selected.remove(s);
      } else {
        _selected[s] = 3; // default = moderate
      }
    });
  }

  void _setIntensity(Symptom s, int intensity) {
    setState(() => _selected[s] = intensity);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final logs = _selected.entries
        .map((e) => SymptomLog(symptom: e.key, intensity: e.value))
        .toList();

    await SymptomsRepository.instance.saveForDate(DateTime.now(), logs);
    await NotesRepository.instance
        .saveForDate(DateTime.now(), _noteController.text);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.symptomsSavedSnack),
        backgroundColor: ArielaTheme.lavender600,
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop();
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    // Symptoms grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                        final isSelected = _selected.containsKey(s);
                        return _SymptomChip(
                          symptom: s,
                          isSelected: isSelected,
                          onTap: () => _toggle(s),
                          l10n: l10n,
                        );
                      },
                    ),

                    // Intensity selectors (only if symptoms selected)
                    if (_selected.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ArielaTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: const Color(0xFFEAE7E1), width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.intensity,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.8,
                                color: ArielaTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._selected.entries.map((entry) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: _IntensitySelector(
                                  symptom: entry.key,
                                  intensity: entry.value,
                                  onChanged: (i) =>
                                      _setIntensity(entry.key, i),
                                  l10n: l10n,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],

                    // Daily note (always visible)
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ArielaTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFEAE7E1), width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.dailyNoteTitle,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.8,
                              color: ArielaTheme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _noteController,
                            maxLines: 4,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(
                              fontSize: 14,
                              color: ArielaTheme.textHeading,
                            ),
                            decoration: InputDecoration(
                              hintText: l10n.dailyNoteHint,
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: ArielaTheme.textMuted,
                              ),
                              filled: true,
                              fillColor: ArielaTheme.surfaceMuted,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
              ArielaButton(
                label: l10n.saveButton,
                icon: Icons.check_rounded,
                onPressed: (_selected.isEmpty &&
                        _noteController.text.trim().isEmpty)
                    ? null
                    : _save,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================

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

// ===========================================================================

class _IntensitySelector extends StatelessWidget {
  const _IntensitySelector({
    required this.symptom,
    required this.intensity,
    required this.onChanged,
    required this.l10n,
  });

  final Symptom symptom;
  final int intensity;
  final ValueChanged<int> onChanged;
  final AppLocalizations l10n;

  String _intensityLabel(int i) {
    if (i <= 2) return l10n.intensityLow;
    if (i <= 3) return l10n.intensityMedium;
    return l10n.intensityHigh;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(symptom.icon, size: 18, color: ArielaTheme.lavender600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            symptom.label(l10n),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ArielaTheme.textHeading,
            ),
          ),
        ),
        ...List.generate(5, (i) {
          final level = i + 1;
          final isActive = level <= intensity;
          return GestureDetector(
            onTap: () => onChanged(level),
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isActive
                    ? ArielaTheme.lavender600
                    : ArielaTheme.surfaceMuted,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            _intensityLabel(intensity),
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 11,
              color: ArielaTheme.lavender600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}