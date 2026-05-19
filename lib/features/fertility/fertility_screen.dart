import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../cycle/cycle_data.dart';
import '../cycle/period_repository.dart';
import 'fertility_math.dart';

class FertilityScreen extends StatelessWidget {
  const FertilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final period = PeriodRepository.instance.getCurrent();

    return Scaffold(
      backgroundColor: ArielaTheme.surfaceBg,
      appBar: AppBar(
        backgroundColor: ArielaTheme.surfaceBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: ArielaTheme.textHeading),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.fertilityTitle,
          style: textTheme.headlineMedium?.copyWith(
            color: ArielaTheme.lavender900,
          ),
        ),
      ),
      body: SafeArea(
        child: period == null
            ? _EmptyState(message: l10n.fertilityNoData)
            : _FertilityContent(period: period, l10n: l10n),
      ),
    );
  }
}

// ===========================================================================

class _FertilityContent extends StatelessWidget {
  const _FertilityContent({required this.period, required this.l10n});

  final PeriodEntry period;
  final AppLocalizations l10n;

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final dayInCycle = FertilityMath.dayOfCycle(period.startDate);
    final phase = FertilityMath.phaseForDay(dayInCycle);
    final daysUntilOvulation =
        FertilityMath.daysUntilOvulation(period.startDate);
    final nextOvulation = DateTime.now().add(Duration(days: daysUntilOvulation));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 8),
        Text(
          l10n.fertilitySubtitle,
          style: const TextStyle(
            fontSize: 14,
            color: ArielaTheme.textBody,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // Current phase hero card
        _PhaseHero(phase: phase, l10n: l10n),

        const SizedBox(height: 16),

        // Next ovulation card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ArielaTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: ArielaTheme.pink50,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.water_drop_outlined,
                  size: 22,
                  color: ArielaTheme.pink600,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.fertilityNextOvulation,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ArielaTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(nextOvulation),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ArielaTheme.textHeading,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.fertilityDaysUntilOvulation(daysUntilOvulation),
                      style: const TextStyle(
                        fontSize: 12,
                        color: ArielaTheme.lavender600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Phase timeline
        _PhaseTimeline(currentPhase: phase, l10n: l10n),

        const SizedBox(height: 24),
      ],
    );
  }
}

// ===========================================================================

class _PhaseHero extends StatelessWidget {
  const _PhaseHero({required this.phase, required this.l10n});

  final CyclePhase phase;
  final AppLocalizations l10n;

  Color get _phaseColor => switch (phase) {
        CyclePhase.menstrual => ArielaTheme.pink50,
        CyclePhase.follicular => ArielaTheme.lavender50,
        CyclePhase.fertile => const Color(0xFFFEF3C7),
        CyclePhase.ovulation => const Color(0xFFFDF2F6),
        CyclePhase.luteal => const Color(0xFFD1FAE5),
      };

  Color get _phaseAccent => switch (phase) {
        CyclePhase.menstrual => ArielaTheme.pink600,
        CyclePhase.follicular => ArielaTheme.lavender600,
        CyclePhase.fertile => const Color(0xFFD97706),
        CyclePhase.ovulation => ArielaTheme.pink600,
        CyclePhase.luteal => const Color(0xFF059669),
      };

  IconData get _phaseIcon => switch (phase) {
        CyclePhase.menstrual => Icons.water_drop_outlined,
        CyclePhase.follicular => Icons.spa_outlined,
        CyclePhase.fertile => Icons.favorite_outline,
        CyclePhase.ovulation => Icons.brightness_high_outlined,
        CyclePhase.luteal => Icons.bedtime_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _phaseColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(_phaseIcon, size: 26, color: _phaseAccent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.fertilityCurrentPhase,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ArielaTheme.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      phase.label(l10n),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: _phaseAccent,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              phase.chance(l10n),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _phaseAccent,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            phase.tip(l10n),
            style: const TextStyle(
              fontSize: 14,
              color: ArielaTheme.textHeading,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================

class _PhaseTimeline extends StatelessWidget {
  const _PhaseTimeline({required this.currentPhase, required this.l10n});

  final CyclePhase currentPhase;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArielaTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...CyclePhase.values.map((phase) {
            final isCurrent = phase == currentPhase;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? ArielaTheme.lavender600
                          : ArielaTheme.surfaceMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    phase.label(l10n),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isCurrent ? FontWeight.w500 : FontWeight.w400,
                      color: isCurrent
                          ? ArielaTheme.lavender900
                          : ArielaTheme.textBody,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    phase.chance(l10n),
                    style: TextStyle(
                      fontSize: 11,
                      color: isCurrent
                          ? ArielaTheme.lavender600
                          : ArielaTheme.textMuted,
                      fontWeight:
                          isCurrent ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ===========================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: ArielaTheme.lavender50,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.local_florist_outlined,
                size: 32,
                color: ArielaTheme.lavender600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: ArielaTheme.textBody,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}