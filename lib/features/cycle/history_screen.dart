import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'cycle_data.dart';
import 'cycle_stats.dart';
import 'period_repository.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final periods = PeriodRepository.instance.getAll();
    final stats = CycleStats.from(periods);

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
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text(
              l10n.historyTitle,
              style: textTheme.headlineLarge?.copyWith(
                color: ArielaTheme.lavender900,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.historySubtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: ArielaTheme.textBody,
              ),
            ),
            const SizedBox(height: 24),

            if (periods.isEmpty)
              _EmptyState(message: l10n.historyEmpty)
            else ...[
              // Stats grid
              _StatsGrid(stats: stats, l10n: l10n),
              const SizedBox(height: 24),

              // Cycle list
              ...periods.asMap().entries.map((entry) {
                final index = entry.key;
                final period = entry.value;
                final cycleNumber = periods.length - index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CycleCard(
                    period: period,
                    cycleNumber: cycleNumber,
                    l10n: l10n,
                  ),
                );
              }),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats, required this.l10n});
  final CycleStats stats;
  final AppLocalizations l10n;

  String _format(double? value) =>
      value == null ? '—' : value.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: l10n.statsAverageCycle,
            value: _format(stats.averageCycleLength),
            unit: l10n.statsDays,
            color: ArielaTheme.lavender600,
            bg: ArielaTheme.lavender50,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: l10n.statsAveragePeriod,
            value: _format(stats.averagePeriodLength),
            unit: l10n.statsDays,
            color: ArielaTheme.pink600,
            bg: ArielaTheme.pink50,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: l10n.statsTotalCycles,
            value: '${stats.totalCycles}',
            unit: '',
            color: ArielaTheme.lavender900,
            bg: const Color(0xFFF4F2EE),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.bg,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 11,
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================================

class _CycleCard extends StatelessWidget {
  const _CycleCard({
    required this.period,
    required this.cycleNumber,
    required this.l10n,
  });

  final PeriodEntry period;
  final int cycleNumber;
  final AppLocalizations l10n;

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final endStr =
        period.endDate == null ? '—' : _formatDate(period.endDate!);
    final duration = period.endDate == null
        ? null
        : period.endDate!.difference(period.startDate).inDays + 1;

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
            decoration: const BoxDecoration(
              color: ArielaTheme.pink50,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.water_drop_outlined,
              size: 20,
              color: ArielaTheme.pink600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.cycleNumber(cycleNumber),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ArielaTheme.textHeading,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatDate(period.startDate)} → $endStr',
                  style: const TextStyle(
                    fontSize: 12,
                    color: ArielaTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (duration != null)
            Text(
              '$duration ${l10n.statsDays}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ArielaTheme.lavender600,
              ),
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
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
              Icons.timeline_outlined,
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
    );
  }
}