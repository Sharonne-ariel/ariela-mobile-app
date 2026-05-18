import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_repository.dart';
import '../auth/sign_in_screen.dart';
import '../../app/locale_provider.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../cycle/period_repository.dart';
import '../cycle/symptoms_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final currentLocale = ref.watch(localeProvider) ??
        Localizations.localeOf(context);

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
          l10n.settingsTitle,
          style: textTheme.headlineMedium?.copyWith(
            color: ArielaTheme.lavender900,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            // ----- Language section -----
            _SectionHeader(label: l10n.settingsLanguage),
            const SizedBox(height: 8),
            _SettingsCard(
              children: [
                _LanguageTile(
                  label: l10n.languageFrench,
                  isSelected: currentLocale.languageCode == 'fr',
                  onTap: () => ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('fr')),
                ),
                const Divider(height: 1, color: Color(0xFFEAE7E1)),
                _LanguageTile(
                  label: l10n.languageEnglish,
                  isSelected: currentLocale.languageCode == 'en',
                  onTap: () => ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('en')),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ----- About section -----
            const SizedBox(height: 32),
            const SizedBox(height: 32),

            // ----- Sync section -----
            _SectionHeader(label: l10n.settingsSync),
            const SizedBox(height: 8),
            _SettingsCard(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.cloud_sync_outlined,
                    color: ArielaTheme.lavender600,
                  ),
                  title: Text(l10n.syncNow),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: ArielaTheme.textMuted,
                  ),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await PeriodRepository.instance.syncFromCloud();
                      await SymptomsRepository.instance.syncFromCloud();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l10n.syncSuccess),
                          backgroundColor: ArielaTheme.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } catch (_) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l10n.syncError),
                          backgroundColor: ArielaTheme.error,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            // ----- About section -----
            _SectionHeader(label: l10n.settingsAbout),
            const SizedBox(height: 8),
            _SettingsCard(
              children: [
                ListTile(
                  title: Text(l10n.settingsVersion),
                  trailing: const Text(
                    '0.1.0',
                    style: TextStyle(color: ArielaTheme.textMuted),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ----- Sign out -----
            _SettingsCard(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: ArielaTheme.error,
                  ),
                  title: Text(
                    l10n.authSignOut,
                    style: const TextStyle(
                      color: ArielaTheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    await AuthRepository.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const SignInScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          color: ArielaTheme.textMuted,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ArielaTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAE7E1), width: 0.5),
      ),
      child: Column(children: children),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          color: isSelected
              ? ArielaTheme.lavender900
              : ArielaTheme.textHeading,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded,
              color: ArielaTheme.lavender600)
          : null,
    );
  }
}