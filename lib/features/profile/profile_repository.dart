import '../../main.dart';

/// User profile data stored in Supabase `profiles` table.
class UserProfile {
  const UserProfile({
    required this.id,
    this.displayName,
    this.birthYear,
    this.language,
  });

  final String id;
  final String? displayName;
  final int? birthYear;
  final String? language;

  factory UserProfile.fromRow(Map<String, dynamic> row) {
    return UserProfile(
      id: row['id'] as String,
      displayName: row['display_name'] as String?,
      birthYear: row['birth_year'] as int?,
      language: row['language'] as String?,
    );
  }
}

/// Reads and writes the current user's profile in Supabase.
///
/// The profile row is auto-created by a trigger on user signup (see DB
/// schema), so [get] should always succeed for a signed-in user.
class ProfileRepository {
  ProfileRepository._();
  static final instance = ProfileRepository._();

  /// Fetch the current user's profile from Supabase.
  /// Returns null if not signed in.
  Future<UserProfile?> get() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final row = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (row == null) return null;
      return UserProfile.fromRow(row);
    } catch (_) {
      return null;
    }
  }

  /// Update the current user's profile.
  Future<void> update({
    String? displayName,
    int? birthYear,
    String? language,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (displayName != null) updates['display_name'] = displayName;
    if (birthYear != null) updates['birth_year'] = birthYear;
    if (language != null) updates['language'] = language;

    await supabase.from('profiles').update(updates).eq('id', userId);
  }
}