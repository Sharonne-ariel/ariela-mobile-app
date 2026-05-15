import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

/// Wraps Supabase auth in a small testable API.
///
/// Keep all auth-related Supabase calls in this file. The rest of the app
/// uses [AuthRepository.instance] without knowing about Supabase directly.
class AuthRepository {
  AuthRepository._();
  static final instance = AuthRepository._();

  /// The current user, or null if signed out.
  User? get currentUser => supabase.auth.currentUser;

  /// True if a user is currently signed in.
  bool get isSignedIn => currentUser != null;

  /// Stream of auth state changes — emits whenever signed in/out.
  Stream<AuthState> get onAuthChange => supabase.auth.onAuthStateChange;

  /// Create a new account with email + password.
  /// Supabase will send a confirmation email if that's enabled in the project.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    return supabase.auth.signUp(email: email, password: password);
  }

  /// Sign in with email + password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return supabase.auth.signInWithPassword(email: email, password: password);
  }

  /// Sign the current user out.
  Future<void> signOut() {
    return supabase.auth.signOut();
  }
}