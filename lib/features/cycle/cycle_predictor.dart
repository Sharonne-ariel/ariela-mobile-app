import 'dart:math' as math;

import 'cycle_data.dart';

/// Regularity level based on cycle length variance.
enum CycleRegularity {
  veryRegular, // stdDev < 2 days
  slightlyIrregular, // 2-5 days
  irregular; // > 5 days
}

/// Personalized cycle predictions based on user's tracked history.
///
/// Falls back to standard 28-day cycle if not enough data (< 2 cycles).
class CyclePredictor {
  CyclePredictor._({
    required this.averageCycleLength,
    required this.averagePeriodLength,
    required this.regularity,
    required this.cyclesAnalyzed,
    required this.isPersonalized,
  });

  /// Build a predictor from the user's tracked periods.
  ///
  /// [periods] must be sorted with most recent first (as returned by
  /// PeriodRepository.getAll()).
  factory CyclePredictor.from(List<PeriodEntry> periods) {
    if (periods.length < 2) {
      return CyclePredictor._(
        averageCycleLength: 28,
        averagePeriodLength: 5,
        regularity: CycleRegularity.veryRegular,
        cyclesAnalyzed: periods.length,
        isPersonalized: false,
      );
    }

    // Compute cycle lengths (start to start, in order from old to new).
    final sortedByDate = [...periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final cycleLengths = <int>[];
    for (var i = 1; i < sortedByDate.length; i++) {
      final diff = sortedByDate[i]
          .startDate
          .difference(sortedByDate[i - 1].startDate)
          .inDays;
      if (diff > 15 && diff < 60) {
        // Filter out absurd values (very short cycles or huge gaps).
        cycleLengths.add(diff);
      }
    }

    if (cycleLengths.isEmpty) {
      return CyclePredictor._(
        averageCycleLength: 28,
        averagePeriodLength: 5,
        regularity: CycleRegularity.veryRegular,
        cyclesAnalyzed: periods.length,
        isPersonalized: false,
      );
    }

    // Use last 6 cycles max for accuracy (more recent = more relevant).
    final recentCycles = cycleLengths.length > 6
        ? cycleLengths.sublist(cycleLengths.length - 6)
        : cycleLengths;

    final avgCycle =
        recentCycles.reduce((a, b) => a + b) / recentCycles.length;

    // Standard deviation
    final variance = recentCycles
            .map((c) => math.pow(c - avgCycle, 2).toDouble())
            .reduce((a, b) => a + b) /
        recentCycles.length;
    final stdDev = math.sqrt(variance);

    // Period lengths
    final periodLengths = sortedByDate
        .where((p) => p.endDate != null)
        .map((p) => p.endDate!.difference(p.startDate).inDays + 1)
        .toList();

    final avgPeriod = periodLengths.isEmpty
        ? 5.0
        : periodLengths.reduce((a, b) => a + b) / periodLengths.length;

    final regularity = stdDev < 2
        ? CycleRegularity.veryRegular
        : stdDev < 5
            ? CycleRegularity.slightlyIrregular
            : CycleRegularity.irregular;

    return CyclePredictor._(
      averageCycleLength: avgCycle.round(),
      averagePeriodLength: avgPeriod.round(),
      regularity: regularity,
      cyclesAnalyzed: recentCycles.length + 1,
      isPersonalized: true,
    );
  }

  final int averageCycleLength;
  final int averagePeriodLength;
  final CycleRegularity regularity;
  final int cyclesAnalyzed;
  final bool isPersonalized;

  /// Predicted next period date.
  DateTime predictNextPeriod(PeriodEntry currentPeriod) {
    return currentPeriod.startDate.add(Duration(days: averageCycleLength));
  }

  /// Predicted ovulation day for the current cycle.
  DateTime predictOvulation(PeriodEntry currentPeriod) {
    // Luteal phase is more constant at 14 days
    return currentPeriod.startDate
        .add(Duration(days: averageCycleLength - 14));
  }
}