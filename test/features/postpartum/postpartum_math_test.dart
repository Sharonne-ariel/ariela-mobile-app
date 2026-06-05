import 'package:ariela/features/postpartum/postpartum_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostpartumMath.daysSinceBirth', () {
    test('returns 0 on the day of birth', () {
      final birth = DateTime(2026, 1, 1);
      expect(PostpartumMath.daysSinceBirth(birth, birth), 0);
    });

    test('returns 7 one week after birth', () {
      final birth = DateTime(2026, 1, 1);
      final today = DateTime(2026, 1, 8);
      expect(PostpartumMath.daysSinceBirth(birth, today), 7);
    });

    test('ignores time-of-day differences', () {
      final birth = DateTime(2026, 1, 1, 23, 0);
      final today = DateTime(2026, 1, 2, 0, 30);
      expect(PostpartumMath.daysSinceBirth(birth, today), 1);
    });
  });

  group('PostpartumMath.weeksSinceBirth', () {
    test('returns 0 in the first 6 days', () {
      final birth = DateTime(2026, 1, 1);
      final today = DateTime(2026, 1, 6);
      expect(PostpartumMath.weeksSinceBirth(birth, today), 0);
    });

    test('returns 1 after 7 days', () {
      final birth = DateTime(2026, 1, 1);
      final today = DateTime(2026, 1, 8);
      expect(PostpartumMath.weeksSinceBirth(birth, today), 1);
    });

    test('returns 6 after 6 weeks (42 days)', () {
      final birth = DateTime(2026, 1, 1);
      final today = birth.add(const Duration(days: 42));
      expect(PostpartumMath.weeksSinceBirth(birth, today), 6);
    });
  });

  group('PostpartumMath.monthsSinceBirth', () {
    test('returns 0 in the first month', () {
      final birth = DateTime(2026, 1, 1);
      final today = DateTime(2026, 1, 20);
      expect(PostpartumMath.monthsSinceBirth(birth, today), 0);
    });

    test('returns 3 after ~90 days', () {
      final birth = DateTime(2026, 1, 1);
      final today = birth.add(const Duration(days: 90));
      expect(PostpartumMath.monthsSinceBirth(birth, today), 3);
    });
  });

  group('PostpartumMath.phaseFor', () {
    test('returns acute in the first 6 weeks', () {
      final birth = DateTime(2026, 1, 1);
      final today = birth.add(const Duration(days: 14));
      expect(PostpartumMath.phaseFor(birth, today), PostpartumPhase.acute);
    });

    test('returns subacute from week 6 to week 12', () {
      final birth = DateTime(2026, 1, 1);
      final today = birth.add(const Duration(days: 50));
      expect(
        PostpartumMath.phaseFor(birth, today),
        PostpartumPhase.subacute,
      );
    });

    test('returns delayed from month 3 to month 6', () {
      final birth = DateTime(2026, 1, 1);
      final today = birth.add(const Duration(days: 120));
      expect(
        PostpartumMath.phaseFor(birth, today),
        PostpartumPhase.delayed,
      );
    });

    test('returns longTerm after 6 months', () {
      final birth = DateTime(2026, 1, 1);
      final today = birth.add(const Duration(days: 200));
      expect(
        PostpartumMath.phaseFor(birth, today),
        PostpartumPhase.longTerm,
      );
    });

    test('boundary: exactly 6 weeks transitions to subacute', () {
      final birth = DateTime(2026, 1, 1);
      final today = birth.add(const Duration(days: 42));
      expect(
        PostpartumMath.phaseFor(birth, today),
        PostpartumPhase.subacute,
      );
    });
  });

  group('PostpartumMath.babyAgeLabel', () {
    test('uses weeks under 12 weeks', () {
      final birth = DateTime(2026, 1, 1);
      final today = birth.add(const Duration(days: 28)); // 4 weeks
      final label = PostpartumMath.babyAgeLabel(
        birth,
        today: today,
        weeksLabel: (w) => '$w weeks old',
        monthsLabel: (m) => '$m months old',
      );
      expect(label, '4 weeks old');
    });

    test('uses months at 12+ weeks', () {
      final birth = DateTime(2026, 1, 1);
      final today = birth.add(const Duration(days: 90)); // ~3 months
      final label = PostpartumMath.babyAgeLabel(
        birth,
        today: today,
        weeksLabel: (w) => '$w weeks old',
        monthsLabel: (m) => '$m months old',
      );
      expect(label, '3 months old');
    });
  });
}