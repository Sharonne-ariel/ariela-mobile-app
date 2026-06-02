import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Phases of postpartum recovery.
enum PostpartumPhase {
  acute, // 0-6 weeks
  subacute, // 6-12 weeks
  delayed, // 3-6 months
  longTerm; // 6+ months

  Color get color => switch (this) {
        PostpartumPhase.acute => ArielaTheme.pink50,
        PostpartumPhase.subacute => ArielaTheme.lavender50,
        PostpartumPhase.delayed => const Color(0xFFD1FAE5),
        PostpartumPhase.longTerm => const Color(0xFFFEF3C7),
      };

  Color get accent => switch (this) {
        PostpartumPhase.acute => ArielaTheme.pink600,
        PostpartumPhase.subacute => ArielaTheme.lavender600,
        PostpartumPhase.delayed => const Color(0xFF059669),
        PostpartumPhase.longTerm => const Color(0xFFD97706),
      };
}

/// Pure math helpers for postpartum tracking.
class PostpartumMath {
  PostpartumMath._();

  /// Days since birth.
  static int daysSinceBirth(DateTime birthDate, [DateTime? today]) {
    final now = today ?? DateTime.now();
    final t = DateTime(now.year, now.month, now.day);
    final b = DateTime(birthDate.year, birthDate.month, birthDate.day);
    return t.difference(b).inDays;
  }

  /// Weeks since birth.
  static int weeksSinceBirth(DateTime birthDate, [DateTime? today]) {
    return daysSinceBirth(birthDate, today) ~/ 7;
  }

  /// Months since birth (approximate, 30 days/month).
  static int monthsSinceBirth(DateTime birthDate, [DateTime? today]) {
    return daysSinceBirth(birthDate, today) ~/ 30;
  }

  /// Current postpartum phase.
  static PostpartumPhase phaseFor(DateTime birthDate, [DateTime? today]) {
    final weeks = weeksSinceBirth(birthDate, today);
    if (weeks < 6) return PostpartumPhase.acute;
    if (weeks < 12) return PostpartumPhase.subacute;
    if (weeks < 26) return PostpartumPhase.delayed; // ~6 months
    return PostpartumPhase.longTerm;
  }

  /// Display the baby's age in a natural way.
  /// - 0-12 weeks: "X weeks"
  /// - 12+ weeks: "X months"
  static String babyAgeLabel(
    DateTime birthDate, {
    DateTime? today,
    required String Function(int weeks) weeksLabel,
    required String Function(int months) monthsLabel,
  }) {
    final weeks = weeksSinceBirth(birthDate, today);
    if (weeks < 12) return weeksLabel(weeks);
    return monthsLabel(monthsSinceBirth(birthDate, today));
  }
}