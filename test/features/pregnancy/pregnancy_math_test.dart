import 'package:ariela/features/pregnancy/pregnancy_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PregnancyMath.currentWeek', () {
    test('returns 1 on the day of last period (week 0+1)', () {
      final lastPeriod = DateTime(2026, 1, 1);
      final week = PregnancyMath.currentWeek(lastPeriod, lastPeriod);
      expect(week, 1);
    });

    test('returns 2 after 7 days', () {
      final lastPeriod = DateTime(2026, 1, 1);
      final today = lastPeriod.add(const Duration(days: 7));
      expect(PregnancyMath.currentWeek(lastPeriod, today), 2);
    });

    test('returns 40 around the due date', () {
      final lastPeriod = DateTime(2026, 1, 1);
      final today = lastPeriod.add(const Duration(days: 273)); // ~39 weeks
      expect(PregnancyMath.currentWeek(lastPeriod, today), 40);
    });
  });

  group('PregnancyMath.trimester', () {
    test('weeks 1-13 are first trimester', () {
      expect(PregnancyMath.trimester(1), 1);
      expect(PregnancyMath.trimester(13), 1);
    });

    test('weeks 14-27 are second trimester', () {
      expect(PregnancyMath.trimester(14), 2);
      expect(PregnancyMath.trimester(20), 2);
      expect(PregnancyMath.trimester(27), 2);
    });

    test('weeks 28-40 are third trimester', () {
      expect(PregnancyMath.trimester(28), 3);
      expect(PregnancyMath.trimester(35), 3);
      expect(PregnancyMath.trimester(40), 3);
    });
  });

  group('PregnancyMath.dueDateFromLastPeriod', () {
    test('adds 280 days to last period', () {
      final lastPeriod = DateTime(2026, 1, 1);
      final due = PregnancyMath.dueDateFromLastPeriod(lastPeriod);
      expect(due, lastPeriod.add(const Duration(days: 280)));
    });
  });

  group('PregnancyMath.lastPeriodFromDueDate', () {
    test('subtracts 280 days from due date', () {
      final due = DateTime(2026, 10, 8);
      final lastPeriod = PregnancyMath.lastPeriodFromDueDate(due);
      expect(lastPeriod, due.subtract(const Duration(days: 280)));
    });

    test('round-trip: dueDate → lastPeriod → dueDate', () {
      final due = DateTime(2026, 10, 8);
      final lastPeriod = PregnancyMath.lastPeriodFromDueDate(due);
      final dueAgain = PregnancyMath.dueDateFromLastPeriod(lastPeriod);
      expect(dueAgain, due);
    });
  });

  group('PregnancyMath.progress', () {
    test('returns 0.0 on day 1', () {
      final lastPeriod = DateTime(2026, 1, 1);
      expect(PregnancyMath.progress(lastPeriod, lastPeriod), 0.0);
    });

    test('returns ~0.5 around 20 weeks (140 days / 280)', () {
      final lastPeriod = DateTime(2026, 1, 1);
      final today = lastPeriod.add(const Duration(days: 140));
      expect(PregnancyMath.progress(lastPeriod, today), 0.5);
    });

    test('returns 1.0 at due date', () {
      final lastPeriod = DateTime(2026, 1, 1);
      final today = lastPeriod.add(const Duration(days: 280));
      expect(PregnancyMath.progress(lastPeriod, today), 1.0);
    });

    test('is clamped at 1.0 even past due date', () {
      final lastPeriod = DateTime(2026, 1, 1);
      final today = lastPeriod.add(const Duration(days: 300));
      expect(PregnancyMath.progress(lastPeriod, today), 1.0);
    });
  });

  group('PregnancyMath.babySizeComparison', () {
    test('returns a known size for week 12', () {
      expect(PregnancyMath.babySizeComparison(12), 'plum');
    });

    test('returns watermelon at week 40', () {
      expect(PregnancyMath.babySizeComparison(40), 'watermelon');
    });

    test('returns dash for weeks before 5', () {
      expect(PregnancyMath.babySizeComparison(3), '—');
    });
  });

  group('PregnancyMath.babySizeComparisonFr', () {
    test('returns French equivalents', () {
      expect(PregnancyMath.babySizeComparisonFr(12), 'prune');
      expect(PregnancyMath.babySizeComparisonFr(40), 'pastèque');
    });
  });
}