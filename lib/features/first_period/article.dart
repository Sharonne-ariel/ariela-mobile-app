import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// A single educational article for the First Period mode.
@immutable
class Article {
  const Article({
    required this.id,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.readMinutes,
  });

  final String id;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final int readMinutes;

  String title(AppLocalizations l10n) => switch (id) {
        'a1' => l10n.article1Title,
        'a2' => l10n.article2Title,
        'a3' => l10n.article3Title,
        'a4' => l10n.article4Title,
        'a5' => l10n.article5Title,
        'a6' => l10n.article6Title,
        _ => '',
      };

  String summary(AppLocalizations l10n) => switch (id) {
        'a1' => l10n.article1Summary,
        'a2' => l10n.article2Summary,
        'a3' => l10n.article3Summary,
        'a4' => l10n.article4Summary,
        'a5' => l10n.article5Summary,
        'a6' => l10n.article6Summary,
        _ => '',
      };

  String content(AppLocalizations l10n) => switch (id) {
        'a1' => l10n.article1Content,
        'a2' => l10n.article2Content,
        'a3' => l10n.article3Content,
        'a4' => l10n.article4Content,
        'a5' => l10n.article5Content,
        'a6' => l10n.article6Content,
        _ => '',
      };
}

/// All articles available in the First Period mode.
const firstPeriodArticles = <Article>[
  Article(
    id: 'a1',
    icon: Icons.favorite_outline,
    iconBg: Color(0xFFFDF2F6),
    iconColor: Color(0xFFE5739A),
    readMinutes: 3,
  ),
  Article(
    id: 'a2',
    icon: Icons.schedule_outlined,
    iconBg: Color(0xFFF3F1FB),
    iconColor: Color(0xFF6B5DD3),
    readMinutes: 2,
  ),
  Article(
    id: 'a3',
    icon: Icons.checklist_rounded,
    iconBg: Color(0xFFFEF3C7),
    iconColor: Color(0xFFD97706),
    readMinutes: 3,
  ),
  Article(
    id: 'a4',
    icon: Icons.backpack_outlined,
    iconBg: Color(0xFFD1FAE5),
    iconColor: Color(0xFF059669),
    readMinutes: 2,
  ),
  Article(
    id: 'a5',
    icon: Icons.healing_outlined,
    iconBg: Color(0xFFFDF2F6),
    iconColor: Color(0xFFE5739A),
    readMinutes: 3,
  ),
  Article(
    id: 'a6',
    icon: Icons.local_hospital_outlined,
    iconBg: Color(0xFFF3F1FB),
    iconColor: Color(0xFF6B5DD3),
    readMinutes: 2,
  ),
];