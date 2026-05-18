import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';
import 'cycle_data.dart';
import 'period_repository.dart';

class EditPeriodScreen extends StatefulWidget {
  const EditPeriodScreen({super.key, required this.period});

  final PeriodEntry period;

  @override
  State<EditPeriodScreen> createState() => _EditPeriodScreenState();
}

class _EditPeriodScreenState extends State<EditPeriodScreen> {
  late DateTime _startDate;
  DateTime? _endDate;
  late final DateTime _originalStartDate;

  @override
  void initState() {
    super.initState();
    _originalStartDate = widget.period.startDate;
    _startDate = widget.period.startDate;
    _endDate = widget.period.endDate;
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ArielaTheme.lavender600,
            onPrimary: Colors.white,
            surface: ArielaTheme.surfaceCard,
            onSurface: ArielaTheme.textHeading,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // Reset end date if it's before the new start
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 5)),
      firstDate: _startDate,
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ArielaTheme.lavender600,
            onPrimary: Colors.white,
            surface: ArielaTheme.surfaceCard,
            onSurface: ArielaTheme.textHeading,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    await PeriodRepository.instance.update(
      originalStartDate: _originalStartDate,
      updated: PeriodEntry(startDate: _startDate, endDate: _endDate),
    );

    if (!mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.cycleUpdated),
        backgroundColor: ArielaTheme.success,
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ArielaTheme.surfaceCard,
        title: Text(l10n.deleteConfirm),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: ArielaTheme.textBody),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.delete,
              style: const TextStyle(
                color: ArielaTheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    await PeriodRepository.instance.delete(_originalStartDate);

    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.cycleDeleted),
        backgroundColor: ArielaTheme.error,
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

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
          l10n.editCycle,
          style: textTheme.headlineMedium?.copyWith(
            color: ArielaTheme.lavender900,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Start date card
              _DateCard(
                label: l10n.startDate,
                value: _formatDate(_startDate),
                onTap: _pickStartDate,
              ),
              const SizedBox(height: 12),

              // End date card
              _DateCard(
                label: l10n.endDate,
                value:
                    _endDate == null ? l10n.endDateNone : _formatDate(_endDate!),
                onTap: _pickEndDate,
              ),

              const Spacer(),

              // Save button
              ArielaButton(
                label: l10n.saveButton,
                icon: Icons.check_rounded,
                onPressed: _save,
              ),
              const SizedBox(height: 10),

              // Delete button
              ArielaButton(
                label: l10n.deleteCycle,
                icon: Icons.delete_outline_rounded,
                variant: ArielaButtonVariant.text,
                onPressed: _confirmDelete,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ArielaTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
        ),
        child: Row(
          children: [
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
                  const SizedBox(height: 4),
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
            const Icon(
              Icons.calendar_today_outlined,
              color: ArielaTheme.lavender600,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}