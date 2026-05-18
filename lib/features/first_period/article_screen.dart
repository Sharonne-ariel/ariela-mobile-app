import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'article.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.article});

  final Article article;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: article.iconBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(article.icon,
                    size: 32, color: article.iconColor),
              ),
              const SizedBox(height: 20),

              // Read time
              Text(
                l10n.minutesRead(article.readMinutes),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ArielaTheme.lavender600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                article.title(l10n),
                style: textTheme.headlineLarge?.copyWith(
                  color: ArielaTheme.lavender900,
                  fontSize: 28,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),

              // Summary
              Text(
                article.summary(l10n),
                style: textTheme.bodyLarge?.copyWith(
                  color: ArielaTheme.textBody,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Divider
              Container(
                height: 1,
                color: const Color(0xFFEAE7E1),
              ),
              const SizedBox(height: 24),

              // Content
              Text(
                article.content(l10n),
                style: textTheme.bodyLarge?.copyWith(
                  color: ArielaTheme.textHeading,
                  height: 1.7,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}