import 'package:flutter/material.dart';

import '../../app/petal_logo.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';
import 'postpartum_repository.dart';
import 'postpartum_screen.dart';

class PostpartumSetupScreen extends StatefulWidget {
  const PostpartumSetupScreen({super.key});

  @override
  State<PostpartumSetupScreen> createState() => _PostpartumSetupScreenState();
}

class _PostpartumSetupScreenState extends State<PostpartumSetupScreen> {
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = now.subtract(const Duration(days: 365 * 2)); // up to 2 years ago
    final lastDate = now; // can't be in the future
    final initialDate = _selectedDate ?? now.subtract(const Duration(days: 30));

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

    await PostpartumRepository.instance.setBirthDate(_selectedDate!);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PostpartumScreen()),
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
                l10n.postpartumSetupTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  color: ArielaTheme.lavender900,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.postpartumSetupSubtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: ArielaTheme.textBody,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.postpartumBirthDate,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: ArielaTheme.textBody,
                ),
              ),
              const SizedBox(height: 12),
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
                        Icons.cake_outlined,
                        color: ArielaTheme.pink600,
                        size: 22,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? _formatDate(_selectedDate!)
                              : l10n.postpartumBirthDateHint,
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