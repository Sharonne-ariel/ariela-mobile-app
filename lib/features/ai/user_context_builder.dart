import 'dart:ui';

import '../cycle/cycle_data.dart';
import '../cycle/cycle_stats.dart';
import '../cycle/period_repository.dart';
import '../cycle/symptoms_repository.dart';
import '../notes/notes_repository.dart';
import '../pregnancy/pregnancy_math.dart';
import '../pregnancy/pregnancy_repository.dart';
import '../profile/profile_repository.dart';

/// Builds the system prompt that gives the AI context about the user.
///
/// The AI uses this to give personalized, relevant answers rather than
/// generic ones.
class UserContextBuilder {
  UserContextBuilder._();

  /// Build a full context string in the user's language.
  /// [locale] is 'fr' or 'en'.
  static Future<String> build(String locale) async {
    final isFrench = locale == 'fr';
    final profile = await ProfileRepository.instance.get();
    final periods = PeriodRepository.instance.getAll();
    final stats = CycleStats.from(periods);
    final pregnancyDate = PregnancyRepository.instance.getLastPeriodDate();

    final lines = <String>[];

    // ----- System role -----
    if (isFrench) {
      lines.add(
        "Tu es l'assistante ARIELA, une assistante bienveillante et "
        "professionnelle spécialisée dans la santé féminine. Tu réponds en "
        "français, avec un ton chaleureux mais informé. Tu utilises 'tu' "
        "pour parler à l'utilisatrice.",
      );
      lines.add(
        "IMPORTANT : tu n'es pas médecin. Pour toute question sérieuse ou "
        "symptôme inquiétant, recommande toujours de consulter un "
        "professionnel de santé.",
      );
    } else {
      lines.add(
        "You are the ARIELA Assistant, a warm and professional helper "
        "specialized in women's health. You answer in English with a "
        "supportive but informed tone. You address the user with 'you'.",
      );
      lines.add(
        "IMPORTANT: you are not a doctor. For any serious question or "
        "concerning symptom, always recommend consulting a healthcare "
        "professional.",
      );
    }

    // ----- User profile -----
    lines.add('');
    lines.add(isFrench ? "=== Profil utilisatrice ===" : "=== User profile ===");

    if (profile?.displayName != null && profile!.displayName!.isNotEmpty) {
      lines.add(
        isFrench
            ? "Prénom : ${profile.displayName}"
            : "Name: ${profile.displayName}",
      );
    }
    if (profile?.birthYear != null) {
      final age = DateTime.now().year - profile!.birthYear!;
      lines.add(isFrench ? "Âge : $age ans" : "Age: $age years");
    }

    // ----- Cycle stats -----
    if (periods.isNotEmpty) {
      lines.add('');
      lines.add(isFrench ? "=== Cycles ===" : "=== Cycles ===");
      lines.add(
        isFrench
            ? "Cycles enregistrés : ${stats.totalCycles}"
            : "Tracked cycles: ${stats.totalCycles}",
      );
      if (stats.averageCycleLength != null) {
        lines.add(
          isFrench
              ? "Durée moyenne du cycle : ${stats.averageCycleLength!.toStringAsFixed(1)} jours"
              : "Average cycle length: ${stats.averageCycleLength!.toStringAsFixed(1)} days",
        );
      }
      if (stats.averagePeriodLength != null) {
        lines.add(
          isFrench
              ? "Durée moyenne des règles : ${stats.averagePeriodLength!.toStringAsFixed(1)} jours"
              : "Average period length: ${stats.averagePeriodLength!.toStringAsFixed(1)} days",
        );
      }

      // Current period info
      final current = periods.first;
      final dayOfCycle = DateTime.now().difference(current.startDate).inDays + 1;
      lines.add(
        isFrench
            ? "Jour actuel du cycle : $dayOfCycle"
            : "Current day of cycle: $dayOfCycle",
      );
    }

    // ----- Recent symptoms (last 14 days) -----
    final fourteenDaysAgo =
        DateTime.now().subtract(const Duration(days: 14));
    final recentSymptoms =
        SymptomsRepository.instance.getForRange(fourteenDaysAgo, DateTime.now());

    if (recentSymptoms.isNotEmpty) {
      lines.add('');
      lines.add(
        isFrench
            ? "=== Symptômes (14 derniers jours) ==="
            : "=== Symptoms (last 14 days) ===",
      );

      // Count frequency of each symptom
      final freq = <String, List<int>>{};
      for (final logs in recentSymptoms.values) {
        for (final log in logs) {
          final name = log.symptom.name;
          freq.putIfAbsent(name, () => []).add(log.intensity);
        }
      }

      // Sort by frequency desc
      final sorted = freq.entries.toList()
        ..sort((a, b) => b.value.length.compareTo(a.value.length));

      for (final entry in sorted.take(8)) {
        final avgIntensity = entry.value.reduce((a, b) => a + b) / entry.value.length;
        lines.add(
          isFrench
              ? "- ${entry.key} : ${entry.value.length} fois, intensité moyenne ${avgIntensity.toStringAsFixed(1)}/5"
              : "- ${entry.key}: ${entry.value.length} times, avg intensity ${avgIntensity.toStringAsFixed(1)}/5",
        );
      }
    }

    // ----- Recent notes (last 7 days) -----
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentNotes =
        NotesRepository.instance.getForRange(sevenDaysAgo, DateTime.now());

    if (recentNotes.isNotEmpty) {
      lines.add('');
      lines.add(
        isFrench
            ? "=== Notes récentes (7 derniers jours) ==="
            : "=== Recent notes (last 7 days) ===",
      );
      final sortedDates = recentNotes.keys.toList()..sort();
      for (final date in sortedDates) {
        final dateStr =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
        lines.add('- $dateStr: ${recentNotes[date]}');
      }
    }

    // ----- Pregnancy -----
    if (pregnancyDate != null) {
      final week = PregnancyMath.currentWeek(pregnancyDate);
      final trimester = PregnancyMath.trimester(week);
      lines.add('');
      lines.add(
        isFrench
            ? "=== Grossesse en cours ==="
            : "=== Active pregnancy ===",
      );
      lines.add(
        isFrench
            ? "Semaine actuelle : $week (trimestre $trimester)"
            : "Current week: $week (trimester $trimester)",
      );
    }

    // ----- Instructions for response style -----
    lines.add('');
    if (isFrench) {
      lines.add(
        "Réponds de manière concise (3-6 phrases max sauf si on te demande un détail), "
        "avec empathie. Quand pertinent, réfère-toi aux données personnelles ci-dessus. "
        "Si la question sort du cadre santé féminine, redirige gentiment.",
      );
    } else {
      lines.add(
        "Answer concisely (3-6 sentences max unless asked for detail), with empathy. "
        "When relevant, refer to the personal data above. If the question is outside "
        "women's health, gently redirect.",
      );
    }

    return lines.join('\n');
  }
}