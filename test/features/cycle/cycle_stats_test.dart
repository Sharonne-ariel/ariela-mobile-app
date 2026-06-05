import 'package:ariela/features/cycle/cycle_data.dart';
import 'package:ariela/features/cycle/cycle_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CycleStats.from with no data', () {
    test('returns nulls when periods is empty', () {
      final stats = CycleStats.from([]);
      expect(stats.totalCycles, 0);
      expect(stats.averageCycleLength, isNull);
      expect(stats.averagePeriodLength, isNull);
    });

    test('returns single-period stats when only 1 period', () {
      final periods = [
        PeriodEntry(
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 5),
        ),
      ];
      final stats = CycleStats.from(periods);
      expect(stats.totalCycles, 1);
      // With only 1 period, no cycle length can be computed
      expect(stats.averageCycleLength, isNull);
      // Period length: Jan 1 → Jan 5 = 5 days
      expect(stats.averagePeriodLength, 5.0);
    });
  });

  group('CycleStats.from with multiple periods', () {
    test('computes average cycle length from 2 periods', () {
      final periods = [
        PeriodEntry(
          startDate: DateTime(2026, 2, 1),
          endDate: DateTime(2026, 2, 5),
        ),
        PeriodEntry(
          startDate: DateTime(2026, 1, 4),
          endDate: DateTime(2026, 1, 8),
        ),
      ];
      final stats = CycleStats.from(periods);
      expect(stats.totalCycles, 2);
      // Jan 4 → Feb 1 = 28 days
      expect(stats.averageCycleLength, 28.0);
    });

    test('computes average period length', () {
      final periods = [
        PeriodEntry(
          startDate: DateTime(2026, 2, 1),
          endDate: DateTime(2026, 2, 6),
        ),
        PeriodEntry(
          startDate: DateTime(2026, 1, 4),
          endDate: DateTime(2026, 1, 7),
        ),
      ];
      final stats = CycleStats.from(periods);
      // (4 + 6) / 2 = 5.0
      // Jan 4 → Jan 7 = 4 days; Feb 1 → Feb 6 = 6 days; avg = 5.0
      expect(stats.averagePeriodLength, 5.0);
    });

    test('handles periods without end date gracefully', () {
      final periods = [
        PeriodEntry(startDate: DateTime(2026, 2, 1)), // ongoing
        PeriodEntry(
          startDate: DateTime(2026, 1, 4),
          endDate: DateTime(2026, 1, 8),
        ),
      ];
      final stats = CycleStats.from(periods);
      expect(stats.totalCycles, 2);
      // Cycle length still computed: Jan 4 → Feb 1 = 28 days
      expect(stats.averageCycleLength, 28.0);
      // Only 1 period has end date, so avg period = 5
      expect(stats.averagePeriodLength, 5.0);
    });
  });
}