import 'cycle_data.dart';

/// Aggregated statistics across a list of periods.
class CycleStats {
  const CycleStats({
    required this.averageCycleLength,
    required this.averagePeriodLength,
    required this.totalCycles,
  });

  /// Mean number of days between successive period start dates.
  /// Null when fewer than 2 periods are tracked.
  final double? averageCycleLength;

  /// Mean duration of a period (start to end), in days.
  /// Null when no period has both start and end dates.
  final double? averagePeriodLength;

  /// Total number of periods logged.
  final int totalCycles;

  /// Compute stats from a list of periods.
  /// Periods are expected to be sorted most-recent-first, but [from] will
  /// re-sort defensively.
  static CycleStats from(List<PeriodEntry> periods) {
    if (periods.isEmpty) {
      return const CycleStats(
        averageCycleLength: null,
        averagePeriodLength: null,
        totalCycles: 0,
      );
    }

    // Sort oldest-first to compute gaps.
    final sorted = [...periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    // Average cycle length: days between successive starts.
    double? avgCycle;
    if (sorted.length >= 2) {
      var total = 0;
      for (var i = 1; i < sorted.length; i++) {
        total += sorted[i].startDate.difference(sorted[i - 1].startDate).inDays;
      }
      avgCycle = total / (sorted.length - 1);
    }

    // Average period length: only for periods with end dates.
    final completed = sorted.where((p) => p.endDate != null).toList();
    double? avgPeriod;
    if (completed.isNotEmpty) {
      var total = 0;
      for (final p in completed) {
        total += p.endDate!.difference(p.startDate).inDays + 1;
      }
      avgPeriod = total / completed.length;
    }

    return CycleStats(
      averageCycleLength: avgCycle,
      averagePeriodLength: avgPeriod,
      totalCycles: sorted.length,
    );
  }
}