import 'package:flutter/material.dart';

import '../../app/petal_logo.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';
import 'cycle_data.dart';
import 'symptoms_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PeriodEntry? _currentPeriod;
  DateTime _displayedMonth = DateTime.now();

  void _togglePeriod() {
    setState(() {
      if (_currentPeriod == null) {
        _currentPeriod = PeriodEntry(startDate: DateTime.now());
      } else if (_currentPeriod!.endDate == null) {
        _currentPeriod = _currentPeriod!.copyWith(endDate: DateTime.now());
      } else {
        _currentPeriod = PeriodEntry(startDate: DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final period = _currentPeriod;

    return Scaffold(
      backgroundColor: ArielaTheme.surfaceBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // ----- Header -----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.homeTitle,
                    style: textTheme.headlineLarge?.copyWith(
                      color: ArielaTheme.lavender900,
                      fontSize: 26,
                    ),
                  ),
                  const PetalLogo(size: 32),
                ],
              ),

              const SizedBox(height: 24),

              // ----- Cycle ring card -----
              _CycleRingCard(period: period, l10n: l10n),

              const SizedBox(height: 16),

              // ----- Period CTA -----
              // ----- Period CTA -----
              ArielaButton(
                label: period != null && period.endDate == null
                    ? l10n.logPeriodEnd
                    : l10n.logPeriod,
                icon: period != null && period.endDate == null
                    ? Icons.check_rounded
                    : Icons.water_drop_outlined,
                onPressed: _togglePeriod,
              ),

              const SizedBox(height: 10),

              // ----- Symptoms CTA -----
              ArielaButton(
                label: l10n.logSymptoms,
                icon: Icons.add_rounded,
                variant: ArielaButtonVariant.secondary,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SymptomsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // ----- Calendar -----
              Text(
                l10n.calendarTitle,
                style: textTheme.headlineMedium?.copyWith(
                  color: ArielaTheme.lavender900,
                ),
              ),
              const SizedBox(height: 12),
              _MonthCalendar(
                month: _displayedMonth,
                periodStart: period?.startDate,
                l10n: l10n,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Cycle ring card
// ===========================================================================

class _CycleRingCard extends StatelessWidget {
  const _CycleRingCard({required this.period, required this.l10n});

  final PeriodEntry? period;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasData = period != null;
    final dayOfCycle =
        hasData ? CycleMath.dayOfCycle(period!.startDate) : 0;
    final daysUntilNext =
        hasData ? CycleMath.daysUntilNextPeriod(period!.startDate) : 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: ArielaTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(180, 180),
                  painter: _RingPainter(
                    progress: hasData
                        ? (dayOfCycle / CycleMath.defaultCycleLengthDays)
                            .clamp(0.0, 1.0)
                        : 0,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hasData ? l10n.cycleDay(dayOfCycle) : '—',
                      style: textTheme.bodySmall?.copyWith(
                        color: ArielaTheme.textMuted,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasData ? '$dayOfCycle' : '—',
                      style: textTheme.displayLarge?.copyWith(
                        color: ArielaTheme.lavender900,
                        fontSize: 48,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasData ? l10n.nextPeriodIn(daysUntilNext) : l10n.noDataYet,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: ArielaTheme.textBody,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final track = Paint()
      ..color = ArielaTheme.lavender50
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final fill = Paint()
      ..color = ArielaTheme.lavender600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2, // start at top
        progress * 2 * 3.14159,
        false,
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}

// ===========================================================================
// Month calendar
// ===========================================================================

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.month,
    required this.periodStart,
    required this.l10n,
  });

  final DateTime month;
  final DateTime? periodStart;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = CycleMath.daysInMonth(month);
    final firstWeekday = CycleMath.firstWeekdayOfMonth(month);
    final totalCells = daysInMonth + firstWeekday;
    final weekdayLetters = CycleMath.weekdayLetters(l10n);
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArielaTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
      ),
      child: Column(
        children: [
          // Month header
          Text(
            '${CycleMath.monthName(month, l10n)} ${month.year}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ArielaTheme.textBody,
            ),
          ),
          const SizedBox(height: 12),
          // Weekday letters
          Row(
            children: weekdayLetters
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ArielaTheme.textMuted,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox.shrink();
              final dayNumber = index - firstWeekday + 1;
              final date = DateTime(month.year, month.month, dayNumber);
              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              final isPeriod = periodStart != null &&
                  CycleMath.isPeriodDay(date, periodStart!);

              Color? bg;
              Color textColor = ArielaTheme.textHeading;
              FontWeight weight = FontWeight.w400;

              if (isPeriod) {
                bg = ArielaTheme.pink600;
                textColor = Colors.white;
                weight = FontWeight.w500;
              } else if (isToday) {
                bg = ArielaTheme.lavender50;
                textColor = ArielaTheme.lavender900;
                weight = FontWeight.w500;
              }

              return Container(
                decoration: BoxDecoration(
                  color: bg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                    fontWeight: weight,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}