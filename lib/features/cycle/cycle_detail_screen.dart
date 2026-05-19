import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'cycle_data.dart';
import 'edit_period_screen.dart';
import 'symptoms_repository.dart';
import 'symptoms_screen.dart';

class CycleDetailScreen extends StatefulWidget {
  const CycleDetailScreen({super.key, required this.period});

  final PeriodEntry period;

  @override
  State<CycleDetailScreen> createState() => _CycleDetailScreenState();
}

class _CycleDetailScreenState extends State<CycleDetailScreen> {
  late PeriodEntry _period;

  @override
  void initState() {
    super.initState();
    _period = widget.period;
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _openEdit() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditPeriodScreen(period: _period),
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final start = _period.startDate;
    final end = _period.endDate ?? DateTime.now();
    final duration = end.difference(start).inDays + 1;

    final logsByDate =
        SymptomsRepository.instance.getForRange(start, end);

    final sortedDates = logsByDate.keys.toList()
      ..sort((a, b) => a.compareTo(b));

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
          l10n.cycleDetailTitle,
          style: textTheme.headlineMedium?.copyWith(
            color: ArielaTheme.lavender900,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _openEdit,
            child: Text(
              l10n.edit,
              style: const TextStyle(
                color: ArielaTheme.lavender600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 8),

            // Period summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ArielaTheme.pink50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: ArielaTheme.pink200,
                  width: 0.5,
                ),
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
                          '${_formatDate(start)} → ${_period.endDate == null ? l10n.cycleDetailOngoing : _formatDate(_period.endDate!)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ArielaTheme.pink900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${l10n.cycleDetailDuration}: $duration ${l10n.statsDays}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: ArielaTheme.textBody,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Text(
              l10n.cycleDetailSymptoms,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8,
                color: ArielaTheme.textMuted,
              ),
            ),
            const SizedBox(height: 12),

            if (sortedDates.isEmpty)
              _EmptyState(message: l10n.cycleDetailNoSymptoms)
            else
              ...sortedDates.map((date) {
                final logs = logsByDate[date]!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _DayCard(date: date, logs: logs, l10n: l10n),
                );
              }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.date,
    required this.logs,
    required this.l10n,
  });

  final DateTime date;
  final List<SymptomLog> logs;
  final AppLocalizations l10n;

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  String _intensityDots(int intensity) {
    return '●' * intensity + '○' * (5 - intensity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ArielaTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ArielaTheme.lavender50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatDate(date),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ArielaTheme.lavender600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: logs.map((log) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: ArielaTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(log.symptom.icon,
                        size: 14, color: ArielaTheme.lavender600),
                    const SizedBox(width: 5),
                    Text(
                      log.symptom.label(l10n),
                      style: const TextStyle(
                        fontSize: 12,
                        color: ArielaTheme.textBody,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _intensityDots(log.intensity),
                      style: const TextStyle(
                        fontSize: 8,
                        color: ArielaTheme.lavender600,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: ArielaTheme.textMuted,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}