import 'package:hive_flutter/hive_flutter.dart';

import '../../main.dart';

/// Local-first repository for postpartum data.
///
/// Stores the baby's birth date (which is used to compute everything else).
class PostpartumRepository {
  PostpartumRepository._();
  static final instance = PostpartumRepository._();

  static const String _hiveKey = 'postpartum_data';

  Box get _box => Hive.box<dynamic>('periods'); // reuse periods box

  /// Returns the stored birth date, or null if postpartum isn't set up.
  DateTime? getBirthDate() {
    final raw = _box.get(_hiveKey);
    if (raw is! Map) return null;
    final dateStr = raw['birth_date'] as String?;
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  /// Set up or update postpartum tracking.
  Future<void> setBirthDate(DateTime date) async {
    await _box.put(_hiveKey, {
      'birth_date': date.toIso8601String(),
    });

    try {
      await _pushToCloud(date);
    } catch (_) {
      // Silent fail.
    }
  }

  /// Clear postpartum data.
  Future<void> clear() async {
    await _box.delete(_hiveKey);
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;
      await supabase.from('postpartum').delete().eq('user_id', userId);
    } catch (_) {}
  }

  Future<void> _pushToCloud(DateTime birthDate) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('postpartum').upsert({
      'user_id': userId,
      'birth_date': birthDate.toIso8601String().split('T').first,
    }, onConflict: 'user_id');
  }
}