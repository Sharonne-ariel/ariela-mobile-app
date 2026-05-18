import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'article.dart';
import 'article_screen.dart';

class FirstPeriodScreen extends StatelessWidget {
  const FirstPeriodScreen({super.key});

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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text(
              l10n.firstPeriodTitle,
              style: textTheme.headlineLarge?.copyWith(
                color: ArielaTheme.lavender900,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.firstPeriodSubtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: ArielaTheme.textBody,
              ),
            ),
            const SizedBox(height: 24),
            ...firstPeriodArticles.map((article) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ArticleCard(article: article, l10n: l10n),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.l10n});

  final Article article;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArticleScreen(article: article),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ArielaTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: article.iconBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(article.icon,
                  size: 24, color: article.iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title(l10n),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ArielaTheme.textHeading,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.summary(l10n),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ArielaTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.minutesRead(article.readMinutes),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: ArielaTheme.lavender600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: ArielaTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}