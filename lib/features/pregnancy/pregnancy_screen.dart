import 'package:flutter/material.dart';

import '../../app/locale_provider.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pregnancy_math.dart';
import 'pregnancy_repository.dart';
import 'pregnancy_setup_screen.dart';

class PregnancyScreen extends ConsumerStatefulWidget {
  const PregnancyScreen({super.key});

  @override
  ConsumerState<PregnancyScreen> createState() => _PregnancyScreenState();
}

class _PregnancyScreenState extends ConsumerState<PregnancyScreen> {
  DateTime? _lastPeriodDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _lastPeriodDate = PregnancyRepository.instance.getLastPeriodDate();
  }

  Future<void> _openEdit() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PregnancySetupScreen()),
    );
    if (mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider) ?? Localizations.localeOf(context);
    final isFrench = locale.languageCode == 'fr';

    // If pregnancy isn't set up, redirect to setup.
    if (_lastPeriodDate == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PregnancySetupScreen()),
          );
        }
      });
      return const Scaffold(
        backgroundColor: ArielaTheme.surfaceBg,
        body: SizedBox.shrink(),
      );
    }

    final lastPeriod = _lastPeriodDate!;
    final week = PregnancyMath.currentWeek(lastPeriod);
    final dayInWeek = PregnancyMath.dayOfWeek(lastPeriod);
    final trimester = PregnancyMath.trimester(week);
    final dueDate = PregnancyMath.dueDateFromLastPeriod(lastPeriod);
    final daysUntil = PregnancyMath.daysUntilDue(dueDate);
    final progress = PregnancyMath.progress(lastPeriod);

    final babySize = isFrench
        ? PregnancyMath.babySizeComparisonFr(week)
        : PregnancyMath.babySizeComparison(week);

    final trimesterLabel = switch (trimester) {
      1 => l10n.pregnancyTrimester1,
      2 => l10n.pregnancyTrimester2,
      _ => l10n.pregnancyTrimester3,
    };
    final trimesterInfo = switch (trimester) {
      1 => l10n.pregnancyTrimester1Info,
      2 => l10n.pregnancyTrimester2Info,
      _ => l10n.pregnancyTrimester3Info,
    };

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
          l10n.pregnancyTitle,
          style: textTheme.headlineMedium?.copyWith(
            color: ArielaTheme.lavender900,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: ArielaTheme.textBody),
            onPressed: _openEdit,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 8),

            // ----- Hero card with week + progress ring -----
            _HeroCard(
              week: week,
              dayInWeek: dayInWeek,
              progress: progress,
              trimester: trimester,
              l10n: l10n,
            ),

            const SizedBox(height: 16),

            // ----- Countdown card -----
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PregnancyMath.trimesterColor(trimester).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.cake_outlined,
                      size: 22,
                      color: ArielaTheme.lavender600,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          daysUntil > 0
                              ? l10n.pregnancyDaysUntilBirth(daysUntil)
                              : l10n.pregnancyOverdue,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ArielaTheme.lavender900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ----- Baby size card -----
            _InfoCard(
              icon: Icons.spa_outlined,
              iconBg: ArielaTheme.pink50,
              iconColor: ArielaTheme.pink600,
              label: l10n.pregnancyBabySize,
              value: babySize,
            ),

            const SizedBox(height: 12),

            // ----- Trimester info card -----
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ArielaTheme.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: PregnancyMath.trimesterColor(trimester)
                              .withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          trimesterLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ArielaTheme.lavender900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    trimesterInfo,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: ArielaTheme.textBody,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.week,
    required this.dayInWeek,
    required this.progress,
    required this.trimester,
    required this.l10n,
  });

  final int week;
  final int dayInWeek;
  final double progress;
  final int trimester;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: ArielaTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
      ),
      child: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(200, 200),
                painter: _RingPainter(
                  progress: progress,
                  color: PregnancyMath.trimesterColor(trimester),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.pregnancyWeek(week),
                    style: const TextStyle(
                      fontSize: 14,
                      color: ArielaTheme.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$week',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w500,
                      color: ArielaTheme.lavender900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.pregnancyDayOfWeek(dayInWeek, week),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ArielaTheme.textBody,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final track = Paint()
      ..color = ArielaTheme.surfaceMuted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2,
        progress * 2 * 3.14159,
        false,
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.color != color;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ArielaTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ArielaTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ArielaTheme.textHeading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}