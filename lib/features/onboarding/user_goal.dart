import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';

/// User's primary goal — corresponds to our four personas.
enum UserGoal {
  firstPeriod,
  cycle,
  fertility,
  pregnancy;

  String label(AppLocalizations l10n) => switch (this) {
        UserGoal.firstPeriod => l10n.goalFirstPeriod,
        UserGoal.cycle => l10n.goalCycle,
        UserGoal.fertility => l10n.goalFertility,
        UserGoal.pregnancy => l10n.goalPregnancy,
      };

  String subtitle(AppLocalizations l10n) => switch (this) {
        UserGoal.firstPeriod => l10n.goalFirstPeriodSub,
        UserGoal.cycle => l10n.goalCycleSub,
        UserGoal.fertility => l10n.goalFertilitySub,
        UserGoal.pregnancy => l10n.goalPregnancySub,
      };

  IconData get icon => switch (this) {
        UserGoal.firstPeriod => Icons.spa_outlined,
        UserGoal.cycle => Icons.refresh_rounded,
        UserGoal.fertility => Icons.local_florist_outlined,
        UserGoal.pregnancy => Icons.child_friendly_outlined,
      };

  Color get iconColor => switch (this) {
        UserGoal.firstPeriod => ArielaTheme.pink600,
        UserGoal.cycle => ArielaTheme.lavender600,
        UserGoal.fertility => const Color(0xFFD97706),
        UserGoal.pregnancy => const Color(0xFF059669),
      };

  Color get iconBg => switch (this) {
        UserGoal.firstPeriod => ArielaTheme.pink50,
        UserGoal.cycle => ArielaTheme.lavender50,
        UserGoal.fertility => const Color(0xFFFEF3C7),
        UserGoal.pregnancy => const Color(0xFFD1FAE5),
      };
}