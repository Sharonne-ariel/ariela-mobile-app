import 'package:flutter/material.dart';

import '../../app/petal_logo.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';
import 'pregnancy_math.dart';
import 'pregnancy_repository.dart';
import 'pregnancy_screen.dart';

class PregnancySetupScreen extends StatefulWidget {
  const PregnancySetupScreen({super.key});

  @override
  State<PregnancySetupScreen> createState() => _PregnancySetupScreenState();
}

class _PregnancySetupScreenState extends State<PregnancySetupScreen> {
  bool _useDueDate = true;
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = _useDueDate
        ? now.subtract(const Duration(days: 30))
        : now.subtract(const Duration(days: 280));
    final lastDate = _useDueDate
        ? now.add(const Duration(days: 280))
        : now;
    final initialDate = _selectedDate ??
        (_useDueDate ? now.add(const Duration(days: 100)) : now);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
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
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (_selectedDate == null) return;

    // Convert selection to last period date (the source of truth).
    final lastPeriodDate = _useDueDate
        ? PregnancyMath.lastPeriodFromDueDate(_selectedDate!)
        : _selectedDate!;

    await PregnancyRepository.instance.setLastPeriodDate(lastPeriodDate);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PregnancyScreen()),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Center(child: PetalLogo(size: 56)),
              const SizedBox(height: 20),
              Text(
                l10n.pregnancySetupTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  color: ArielaTheme.lavender900,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.pregnancySetupSubtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: ArielaTheme.textBody,
                ),
              ),
              const SizedBox(height: 32),

              // Date input mode toggle
              _ToggleOption(
                label: _useDueDate
                    ? l10n.pregnancyDueDate
                    : l10n.pregnancyLastPeriodDate,
                isSelected: true,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _useDueDate = !_useDueDate;
                    _selectedDate = null;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    _useDueDate
                        ? l10n.pregnancyConceptionDate
                        : l10n.pregnancyDueDate,
                    style: const TextStyle(
                      fontSize: 13,
                      color: ArielaTheme.lavender600,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Date picker card
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: ArielaTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedDate != null
                          ? ArielaTheme.lavender600
                          : const Color(0xFFEAE7E1),
                      width: _selectedDate != null ? 1.5 : 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: ArielaTheme.lavender600,
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? _formatDate(_selectedDate!)
                              : l10n.pregnancyDueDateHint,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _selectedDate != null
                                ? FontWeight.w500
                                : FontWeight.w400,
                            color: _selectedDate != null
                                ? ArielaTheme.textHeading
                                : ArielaTheme.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              ArielaButton(
                label: l10n.continueButton,
                icon: Icons.arrow_forward_rounded,
                onPressed: _selectedDate == null ? null : _save,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: ArielaTheme.textBody,
      ),
    );
  }
}