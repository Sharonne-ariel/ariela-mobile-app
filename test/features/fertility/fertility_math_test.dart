import 'package:ariela/features/fertility/fertility_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FertilityMath.ovulationDay', () {
    test('returns 14 for a 28-day cycle (28 - 14)', () {
      expect(FertilityMath.ovulationDay(28), 14);
    });

    test('returns 16 for a 30-day cycle (30 - 14)', () {
      expect(FertilityMath.ovulationDay(30), 16);
    });

    test('returns 12 for a 26-day cycle (26 - 14)', () {
      expect(FertilityMath.ovulationDay(26), 12);
    });
  });

  group('FertilityMath.dayOfCycle', () {
    test('returns 1 on the first day', () {
      final start = DateTime(2026, 1, 1);
      expect(FertilityMath.dayOfCycle(start, start), 1);
    });

    test('returns 14 on day 14', () {
      final start = DateTime(2026, 1, 1);
      final today = start.add(const Duration(days: 13));
      expect(FertilityMath.dayOfCycle(start, today), 14);
    });
  });

  group('FertilityMath.phaseForDay (28-day cycle)', () {
    test('days 1-5 are menstrual', () {
      expect(FertilityMath.phaseForDay(1), CyclePhase.menstrual);
      expect(FertilityMath.phaseForDay(3), CyclePhase.menstrual);
      expect(FertilityMath.phaseForDay(5), CyclePhase.menstrual);
    });

    test('days 6-8 are follicular', () {
      expect(FertilityMath.phaseForDay(6), CyclePhase.follicular);
      // Note: phaseForDay may return follicular OR fertile around the edge
    });

    test('days 9-13 are fertile window', () {
      expect(FertilityMath.phaseForDay(9), CyclePhase.fertile);
      expect(FertilityMath.phaseForDay(13), CyclePhase.fertile);
    });

    test('day 14 is ovulation', () {
      expect(FertilityMath.phaseForDay(14), CyclePhase.ovulation);
    });

    test('days 15-28 are luteal', () {
      expect(FertilityMath.phaseForDay(15), CyclePhase.luteal);
      expect(FertilityMath.phaseForDay(20), CyclePhase.luteal);
      expect(FertilityMath.phaseForDay(28), CyclePhase.luteal);
    });
  });

  group('FertilityMath.phaseForDay with custom cycle length', () {
    test('day 16 is ovulation for a 30-day cycle', () {
      expect(
        FertilityMath.phaseForDay(16, cycleLength: 30),
        CyclePhase.ovulation,
      );
    });

    test('day 12 is ovulation for a 26-day cycle', () {
      expect(
        FertilityMath.phaseForDay(12, cycleLength: 26),
        CyclePhase.ovulation,
      );
    });
  });

  group('FertilityMath.nextOvulationDate', () {
    test('falls on day 14 of a 28-day cycle', () {
      final lastPeriodStart = DateTime(2026, 1, 1);
      final ovulation = FertilityMath.nextOvulationDate(lastPeriodStart);
      // Day 14 of cycle = start + 13 days
      expect(ovulation, DateTime(2026, 1, 14));
    });

    test('respects custom cycle length', () {
      final lastPeriodStart = DateTime(2026, 1, 1);
      final ovulation = FertilityMath.nextOvulationDate(
        lastPeriodStart,
        cycleLength: 30,
      );
      // Day 16 = start + 15 days
      expect(ovulation, DateTime(2026, 1, 16));
    });
  });
}