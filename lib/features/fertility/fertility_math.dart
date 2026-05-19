import '../../l10n/generated/app_localizations.dart';

/// Pure helpers for computing fertility predictions from cycle data.
///
/// Model (textbook approximation):
/// - Ovulation = day 14 of a 28-day cycle (or cycleLength - 14 from start)
/// - Fertile window = 5 days before ovulation + ovulation day = 6 days total
/// - Menstrual phase = first 5 days
/// - Follicular phase = day 6 → day before fertile window
/// - Luteal phase = day after ovulation → next period
enum CyclePhase {
  menstrual,
  follicular,
  fertile,
  ovulation,
  luteal;

  String label(AppLocalizations l10n) => switch (this) {
        CyclePhase.menstrual => l10n.fertilityPhaseMenstrual,
        CyclePhase.follicular => l10n.fertilityPhaseFollicular,
        CyclePhase.fertile => l10n.fertilityPhaseFertile,
        CyclePhase.ovulation => l10n.fertilityPhaseOvulation,
        CyclePhase.luteal => l10n.fertilityPhaseLuteal,
      };

  String tip(AppLocalizations l10n) => switch (this) {
        CyclePhase.menstrual => l10n.fertilityTipMenstrual,
        CyclePhase.follicular => l10n.fertilityTipFollicular,
        CyclePhase.fertile => l10n.fertilityTipFertile,
        CyclePhase.ovulation => l10n.fertilityTipOvulation,
        CyclePhase.luteal => l10n.fertilityTipLuteal,
      };

  String chance(AppLocalizations l10n) => switch (this) {
        CyclePhase.menstrual => l10n.fertilityChanceLow,
        CyclePhase.follicular => l10n.fertilityChanceLow,
        CyclePhase.fertile => l10n.fertilityChanceHigh,
        CyclePhase.ovulation => l10n.fertilityChancePeak,
        CyclePhase.luteal => l10n.fertilityChanceMedium,
      };
}

class FertilityMath {
  FertilityMath._();

  static const int defaultCycleLength = 28;
  static const int menstrualLength = 5;
  static const int fertileWindowDays = 5; // 5 days before ovulation
  // Ovulation day = cycleLength - 14 (standard textbook).

  /// Day of cycle (1-based).
  static int dayOfCycle(DateTime lastPeriodStart, [DateTime? today]) {
    final now = today ?? DateTime.now();
    final t = DateTime(now.year, now.month, now.day);
    final s = DateTime(lastPeriodStart.year, lastPeriodStart.month,
        lastPeriodStart.day);
    return t.difference(s).inDays + 1;
  }

  /// Ovulation day number for a cycle of [cycleLength] days.
  static int ovulationDay(int cycleLength) => cycleLength - 14;

  /// Date of next ovulation.
  static DateTime nextOvulationDate(
    DateTime lastPeriodStart, {
    int cycleLength = defaultCycleLength,
  }) {
    final ovDay = ovulationDay(cycleLength);
    return lastPeriodStart.add(Duration(days: ovDay - 1));
  }

  /// Returns the phase for [date] given [lastPeriodStart] and [cycleLength].
  static CyclePhase phaseForDay(
    int dayInCycle, {
    int cycleLength = defaultCycleLength,
  }) {
    final ovDay = ovulationDay(cycleLength);
    final fertileStart = ovDay - fertileWindowDays;

    if (dayInCycle <= menstrualLength) return CyclePhase.menstrual;
    if (dayInCycle == ovDay) return CyclePhase.ovulation;
    if (dayInCycle >= fertileStart && dayInCycle < ovDay) {
      return CyclePhase.fertile;
    }
    if (dayInCycle > ovDay) return CyclePhase.luteal;
    return CyclePhase.follicular;
  }

  /// Days until next ovulation. Negative if past ovulation for current cycle
  /// (then it's days until next cycle's ovulation).
  static int daysUntilOvulation(
    DateTime lastPeriodStart, {
    int cycleLength = defaultCycleLength,
    DateTime? today,
  }) {
    final now = today ?? DateTime.now();
    final t = DateTime(now.year, now.month, now.day);
    var ovDate = nextOvulationDate(lastPeriodStart, cycleLength: cycleLength);

    // If today is past this cycle's ovulation, project to next cycle.
    while (!ovDate.isAfter(t)) {
      ovDate = ovDate.add(Duration(days: cycleLength));
    }

    return ovDate.difference(t).inDays;
  }
}