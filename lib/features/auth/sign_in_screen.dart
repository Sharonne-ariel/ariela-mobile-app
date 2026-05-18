import 'package:flutter/material.dart';

import '../../app/petal_logo.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';
import '../../ui/components/ariela_text_field.dart';
import '../onboarding/welcome_screen.dart';
import 'auth_repository.dart';
import 'sign_up_screen.dart';
import '../cycle/period_repository.dart';
import '../cycle/symptoms_repository.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String s) {
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return r.hasMatch(s);
  }

  Future<void> _signIn() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _emailError = !_isValidEmail(email) ? l10n.authInvalidEmail : null;
      _passwordError =
          password.length < 6 ? l10n.authPasswordTooShort : null;
    });

    if (_emailError != null || _passwordError != null) return;

    setState(() => _loading = true);

    try {
      await AuthRepository.instance.signIn(email: email, password: password);

      // Pull cloud data down into local Hive after successful sign-in.
      await PeriodRepository.instance.syncFromCloud();
      await SymptomsRepository.instance.syncFromCloud();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.authError}\n$e'),
          backgroundColor: ArielaTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ArielaTheme.surfaceBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              const Center(child: PetalLogo(size: 72)),
              const SizedBox(height: 16),
              Text(
                l10n.appName,
                textAlign: TextAlign.center,
                style: textTheme.displayLarge?.copyWith(
                  color: ArielaTheme.lavender900,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.authSignIn,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: ArielaTheme.textBody,
                ),
              ),
              const SizedBox(height: 40),
              ArielaTextField(
                label: l10n.authEmail,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                errorText: _emailError,
              ),
              const SizedBox(height: 16),
              ArielaTextField(
                label: l10n.authPassword,
                controller: _passwordController,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                errorText: _passwordError,
              ),
              const SizedBox(height: 32),
              ArielaButton(
                label: _loading ? '...' : l10n.authSignIn,
                icon: Icons.arrow_forward_rounded,
                onPressed: _loading ? null : _signIn,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: Text(
                    '${l10n.authNoAccount} ${l10n.authSignUp}',
                    style: const TextStyle(
                      color: ArielaTheme.lavender600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}