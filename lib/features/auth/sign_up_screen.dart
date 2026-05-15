import 'package:flutter/material.dart';

import '../../app/petal_logo.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/components/ariela_button.dart';
import '../../ui/components/ariela_text_field.dart';
import 'auth_repository.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String s) {
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return r.hasMatch(s);
  }

  Future<void> _signUp() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    setState(() {
      _emailError = !_isValidEmail(email) ? l10n.authInvalidEmail : null;
      _passwordError =
          password.length < 6 ? l10n.authPasswordTooShort : null;
      _confirmError =
          confirm != password ? l10n.authPasswordsDoNotMatch : null;
    });

    if (_emailError != null ||
        _passwordError != null ||
        _confirmError != null) {
      return;
    }

    setState(() => _loading = true);

    try {
      await AuthRepository.instance.signUp(email: email, password: password);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.authCheckEmail),
          backgroundColor: ArielaTheme.lavender600,
          duration: const Duration(seconds: 4),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignInScreen()),
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Center(child: PetalLogo(size: 56)),
              const SizedBox(height: 16),
              Text(
                l10n.authSignUp,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  color: ArielaTheme.lavender900,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 32),
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
                autofillHints: const [AutofillHints.newPassword],
                errorText: _passwordError,
              ),
              const SizedBox(height: 16),
              ArielaTextField(
                label: l10n.authConfirmPassword,
                controller: _confirmController,
                obscureText: true,
                errorText: _confirmError,
              ),
              const SizedBox(height: 32),
              ArielaButton(
                label: _loading ? '...' : l10n.authSignUp,
                icon: Icons.arrow_forward_rounded,
                onPressed: _loading ? null : _signUp,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const SignInScreen(),
                      ),
                    );
                  },
                  child: Text(
                    '${l10n.authHasAccount} ${l10n.authSignIn}',
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