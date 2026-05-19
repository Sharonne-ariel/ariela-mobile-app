import 'package:hive_flutter/hive_flutter.dart';

import '../../main.dart';

/// Local-first repository for pregnancy data.
///
/// Stores the last period date (which is used to compute everything else).
/// Syncs to Supabase `pregnancies` table when signed in.
class PregnancyRepository {
  PregnancyRepository._();
  static final instance = PregnancyRepository._();

  static const String _hiveKey = 'pregnancy_data';

  Box get _box => Hive.box<dynamic>('periods');

  /// Returns the stored last period date, or null if pregnancy isn't set up.
  DateTime? getLastPeriodDate() {
    final raw = _box.get(_hiveKey);
    if (raw is! Map) return null;
    final dateStr = raw['last_period_date'] as String?;
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  /// Set up or update pregnancy tracking.
  Future<void> setLastPeriodDate(DateTime date) async {
    await _box.put(_hiveKey, {
      'last_period_date': date.toIso8601String(),
    });

    try {
      await _pushToCloud(date);
    } catch (_) {
      // Silent fail.
    }
  }

  /// Clear pregnancy data (e.g., after birth).
  Future<void> clear() async {
    await _box.delete(_hiveKey);
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;
      await supabase.from('pregnancies').delete().eq('user_id', userId);
    } catch (_) {}
  }

  Future<void> _pushToCloud(DateTime lastPeriodDate) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('pregnancies').upsert({
      'user_id': userId,
      'last_period_date':
          lastPeriodDate.toIso8601String().split('T').first,
    }, onConflict: 'user_id');
  }
}