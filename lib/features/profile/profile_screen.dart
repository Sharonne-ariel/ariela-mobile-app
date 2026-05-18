import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../main.dart';
import '../../ui/components/ariela_button.dart';
import '../../ui/components/ariela_text_field.dart';
import 'profile_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _birthYearController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileRepository.instance.get();
    if (!mounted) return;
    setState(() {
      _nameController.text = profile?.displayName ?? '';
      _birthYearController.text = profile?.birthYear?.toString() ?? '';
      _loading = false;
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);

    final name = _nameController.text.trim();
    final yearStr = _birthYearController.text.trim();
    final year = int.tryParse(yearStr);

    try {
      await ProfileRepository.instance.update(
        displayName: name.isEmpty ? null : name,
        birthYear: year,
      );
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.profileSaved),
          backgroundColor: ArielaTheme.success,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('${l10n.authError}\n$e'),
          backgroundColor: ArielaTheme.error,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final email = supabase.auth.currentUser?.email ?? '—';

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
          l10n.profileTitle,
          style: textTheme.headlineMedium?.copyWith(
            color: ArielaTheme.lavender900,
          ),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: ArielaTheme.lavender600,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),

                    // Avatar circle (initials)
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: ArielaTheme.lavender200,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _initials(email),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: ArielaTheme.lavender900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email (read-only)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: ArielaTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            color: ArielaTheme.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.profileEmail,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: ArielaTheme.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: ArielaTheme.textBody,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name
                    ArielaTextField(
                      label: l10n.profileDisplayName,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),

                    // Birth year
                    ArielaTextField(
                      label: l10n.profileBirthYear,
                      controller: _birthYearController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),

                    ArielaButton(
                      label: _saving ? '...' : l10n.profileSave,
                      icon: Icons.check_rounded,
                      onPressed: _saving ? null : _save,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  String _initials(String email) {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final parts = name.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    if (email.isNotEmpty) return email[0].toUpperCase();
    return '?';
  }
}