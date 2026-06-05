import 'package:ariela/features/cycle/cycle_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CycleMath.dayOfCycle', () {
    test('returns 1 on the day the period starts', () {
      final start = DateTime(2026, 1, 1);
      final result = CycleMath.dayOfCycle(start, start);
      expect(result, 1);
    });

    test('returns 5 four days after period start', () {
      final start = DateTime(2026, 1, 1);
      final today = DateTime(2026, 1, 5);
      final result = CycleMath.dayOfCycle(start, today);
      expect(result, 5);
    });

    test('returns 28 on the last day of a 28-day cycle', () {
      final start = DateTime(2026, 1, 1);
      final today = DateTime(2026, 1, 28);
      final result = CycleMath.dayOfCycle(start, today);
      expect(result, 28);
    });

    test('ignores time-of-day differences', () {
      final start = DateTime(2026, 1, 1, 23, 59);
      final today = DateTime(2026, 1, 2, 0, 1);
      final result = CycleMath.dayOfCycle(start, today);
      expect(result, 2, reason: 'Only the date part should matter');
    });
  });

  group('CycleMath.daysUntilNextPeriod', () {
    test('returns the cycle length minus elapsed days', () {
      // On day 1 of a fresh cycle, we expect ~28 days until next period
      final start = DateTime(2026, 1, 1);
      final result = CycleMath.daysUntilNextPeriod(start, start);
      expect(result, inInclusiveRange(27, 28),
          reason: 'Should return close to a full 28-day cycle');
    });

    test('returns 0 on the predicted day of next period', () {
      final start = DateTime(2026, 1, 1);
      final today = start.add(const Duration(days: 28));
      final result = CycleMath.daysUntilNextPeriod(start, today);
      expect(result, 0);
    });

    test('returns a meaningful value when cycle is delayed', () {
      // 30 days after start = 2 days late = -2 means "2 days late"
      final start = DateTime(2026, 1, 1);
      final today = start.add(const Duration(days: 30));
      final result = CycleMath.daysUntilNextPeriod(start, today);
      // We accept either 0 (clamped) or -2 (signed) — both are valid designs.
      expect(result, lessThanOrEqualTo(0),
          reason: 'When cycle is late, value should be 0 or negative');
    });
  });

  group('CycleMath.isPeriodDay', () {
    test('returns true on the start day', () {
      final start = DateTime(2026, 1, 1);
      expect(CycleMath.isPeriodDay(start, start), true);
    });

    test('returns true within the default 5-day period window', () {
      final start = DateTime(2026, 1, 1);
      final day3 = DateTime(2026, 1, 3);
      expect(CycleMath.isPeriodDay(day3, start), true);
    });

    test('returns false after the period window ends', () {
      final start = DateTime(2026, 1, 1);
      final day10 = DateTime(2026, 1, 10);
      expect(CycleMath.isPeriodDay(day10, start), false);
    });

    test('returns false before the start date', () {
      final start = DateTime(2026, 1, 5);
      final dayBefore = DateTime(2026, 1, 1);
      expect(CycleMath.isPeriodDay(dayBefore, start), false);
    });
  });

  group('CycleMath.daysInMonth', () {
    test('January has 31 days', () {
      final jan = DateTime(2026, 1, 1);
      expect(CycleMath.daysInMonth(jan), 31);
    });

    test('February 2026 has 28 days (non-leap year)', () {
      final feb = DateTime(2026, 2, 1);
      expect(CycleMath.daysInMonth(feb), 28);
    });

    test('February 2024 has 29 days (leap year)', () {
      final feb = DateTime(2024, 2, 1);
      expect(CycleMath.daysInMonth(feb), 29);
    });

    test('April has 30 days', () {
      final apr = DateTime(2026, 4, 1);
      expect(CycleMath.daysInMonth(apr), 30);
    });
  });
}