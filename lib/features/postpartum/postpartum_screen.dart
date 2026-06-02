import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'postpartum_math.dart';
import 'postpartum_repository.dart';
import 'postpartum_setup_screen.dart';

class PostpartumScreen extends StatefulWidget {
  const PostpartumScreen({super.key});

  @override
  State<PostpartumScreen> createState() => _PostpartumScreenState();
}

class _PostpartumScreenState extends State<PostpartumScreen> {
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _birthDate = PostpartumRepository.instance.getBirthDate();
  }

  Future<void> _openEdit() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PostpartumSetupScreen()),
    );
    if (mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    if (_birthDate == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PostpartumSetupScreen()),
          );
        }
      });
      return const Scaffold(
        backgroundColor: ArielaTheme.surfaceBg,
        body: SizedBox.shrink(),
      );
    }

    final birth = _birthDate!;
    final weeks = PostpartumMath.weeksSinceBirth(birth);
    final days = PostpartumMath.daysSinceBirth(birth);
    final phase = PostpartumMath.phaseFor(birth);

    final phaseLabel = switch (phase) {
      PostpartumPhase.acute => l10n.postpartumPhaseAcute,
      PostpartumPhase.subacute => l10n.postpartumPhaseSubacute,
      PostpartumPhase.delayed => l10n.postpartumPhaseDelayed,
      PostpartumPhase.longTerm => l10n.postpartumPhaseLongTerm,
    };
    final phaseInfo = switch (phase) {
      PostpartumPhase.acute => l10n.postpartumPhaseAcuteInfo,
      PostpartumPhase.subacute => l10n.postpartumPhaseSubacuteInfo,
      PostpartumPhase.delayed => l10n.postpartumPhaseDelayedInfo,
      PostpartumPhase.longTerm => l10n.postpartumPhaseLongTermInfo,
    };

    final babyAge = PostpartumMath.babyAgeLabel(
      birth,
      weeksLabel: l10n.postpartumWeeksOld,
      monthsLabel: l10n.postpartumMonthsOld,
    );

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
          l10n.postpartumTitle,
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

            // Hero card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: phase.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weeks > 0
                        ? l10n.postpartumWeek(weeks)
                        : l10n.postpartumDay(days),
                    style: const TextStyle(
                      fontSize: 14,
                      color: ArielaTheme.textBody,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phaseLabel,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: phase.accent,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.child_friendly_outlined,
                            size: 14, color: phase.accent),
                        const SizedBox(width: 6),
                        Text(
                          babyAge,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: phase.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Phase info card
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
                      const Icon(Icons.spa_outlined,
                          size: 18, color: ArielaTheme.lavender600),
                      const SizedBox(width: 8),
                      Text(
                        phaseLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ArielaTheme.textHeading,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    phaseInfo,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: ArielaTheme.textBody,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Mental health card (important for postpartum!)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ArielaTheme.lavender50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: ArielaTheme.lavender200,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite_outline,
                          size: 18, color: ArielaTheme.lavender600),
                      const SizedBox(width: 8),
                      Text(
                        l10n.postpartumMentalHealthTitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ArielaTheme.lavender900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.postpartumMentalHealthInfo,
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