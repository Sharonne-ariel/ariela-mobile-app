import 'package:flutter/foundation.dart';

import '../../l10n/generated/app_localizations.dart';

/// A single recorded period (from start_date to end_date).
@immutable
class PeriodEntry {
  const PeriodEntry({required this.startDate, this.endDate});

  final DateTime startDate;
  final DateTime? endDate;

  PeriodEntry copyWith({DateTime? endDate}) =>
      PeriodEntry(startDate: startDate, endDate: endDate ?? this.endDate);
}

/// Pure cycle-math helpers — no UI, no state, no side effects.
///
/// Default cycle length is 28 days. This is a simplification for MVP.
/// Later we'll compute the user's actual average from past cycles.
class CycleMath {
  CycleMath._();

  static const int defaultCycleLengthDays = 28;
  static const int defaultPeriodLengthDays = 5;

  /// How many days since this period started.
  static int dayOfCycle(DateTime periodStart, [DateTime? today]) {
    final now = today ?? DateTime.now();
    final start = DateTime(periodStart.year, periodStart.month, periodStart.day);
    final t = DateTime(now.year, now.month, now.day);
    return t.difference(start).inDays + 1;
  }

  /// Days until next period (negative if already overdue).
  static int daysUntilNextPeriod(DateTime lastPeriodStart, [DateTime? today]) {
    final next = lastPeriodStart.add(
      const Duration(days: defaultCycleLengthDays),
    );
    final now = today ?? DateTime.now();
    final t = DateTime(now.year, now.month, now.day);
    return next.difference(t).inDays;
  }

  /// Localized month name for [date].
  static String monthName(DateTime date, AppLocalizations l10n) {
    return switch (date.month) {
      1 => l10n.monthJan,
      2 => l10n.monthFeb,
      3 => l10n.monthMar,
      4 => l10n.monthApr,
      5 => l10n.monthMay,
      6 => l10n.monthJun,
      7 => l10n.monthJul,
      8 => l10n.monthAug,
      9 => l10n.monthSep,
      10 => l10n.monthOct,
      11 => l10n.monthNov,
      _ => l10n.monthDec,
    };
  }

  /// Localized abbreviated weekday letters, starting Monday.
  static List<String> weekdayLetters(AppLocalizations l10n) => [
        l10n.dayMon,
        l10n.dayTue,
        l10n.dayWed,
        l10n.dayThu,
        l10n.dayFri,
        l10n.daySat,
        l10n.daySun,
      ];

  /// Total days in [date]'s month.
  static int daysInMonth(DateTime date) {
    final firstNext = (date.month == 12)
        ? DateTime(date.year + 1, 1, 1)
        : DateTime(date.year, date.month + 1, 1);
    return firstNext.subtract(const Duration(days: 1)).day;
  }

  /// Weekday of the first day of [date]'s month, Monday = 0 ... Sunday = 6.
  static int firstWeekdayOfMonth(DateTime date) {
    final first = DateTime(date.year, date.month, 1);
    return first.weekday - 1; // DateTime.weekday: Monday = 1
  }

  /// Returns true if [date] falls within the period that started on [start]
  /// with the default period length.
  static bool isPeriodDay(DateTime date, DateTime start) {
    final s = DateTime(start.year, start.month, start.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = d.difference(s).inDays;
    return diff >= 0 && diff < defaultPeriodLengthDays;
  }
}