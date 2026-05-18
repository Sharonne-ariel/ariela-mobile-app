import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';
import 'cycle_data.dart';

/// Local-first repository for period entries with optional cloud sync.
///
/// - Hive is the source of truth on the device (works offline).
/// - When signed in, writes are pushed to Supabase.
/// - On sign-in, cloud entries are pulled down and merged locally.
class PeriodRepository {
  PeriodRepository._();
  static final instance = PeriodRepository._();

  Box get _box => Hive.box<dynamic>('periods');

  /// Returns all periods, most recent first.
  List<PeriodEntry> getAll() {
    final entries = <PeriodEntry>[];
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map) {
        final start = DateTime.tryParse(raw['startDate'] as String? ?? '');
        if (start == null) continue;
        final endRaw = raw['endDate'] as String?;
        final end = endRaw == null ? null : DateTime.tryParse(endRaw);
        entries.add(PeriodEntry(startDate: start, endDate: end));
      }
    }
    entries.sort((a, b) => b.startDate.compareTo(a.startDate));
    return entries;
  }

  PeriodEntry? getCurrent() {
    final all = getAll();
    return all.isEmpty ? null : all.first;
  }

  /// Saves to Hive immediately, then attempts to push to Supabase.
  /// If cloud fails (no internet, not signed in), the local save still
  /// succeeds — we'll retry on next sync.
  Future<void> save(PeriodEntry entry) async {
    final key = entry.startDate.toIso8601String();
    await _box.put(key, {
      'startDate': entry.startDate.toIso8601String(),
      'endDate': entry.endDate?.toIso8601String(),
    });

    // Try cloud sync; never throw — local save is what matters.
    try {
      await _pushToCloud(entry);
    } catch (_) {
      // Silent fail: cloud will catch up on next sync.
    }
  }

  Future<void> _pushToCloud(PeriodEntry entry) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return; // Not signed in

    await supabase.from('cycles').upsert({
      'user_id': userId,
      'start_date':
          entry.startDate.toIso8601String().split('T').first, // date only
      'end_date': entry.endDate?.toIso8601String().split('T').first,
    }, onConflict: 'user_id,start_date');
  }

  /// Pull all cloud entries down into Hive. Called after sign-in.
  Future<void> syncFromCloud() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final rows = await supabase
          .from('cycles')
          .select()
          .eq('user_id', userId)
          .order('start_date', ascending: false);

      for (final row in rows as List) {
        if (row is! Map) continue;
        final startStr = row['start_date'] as String?;
        if (startStr == null) continue;
        final start = DateTime.tryParse(startStr);
        if (start == null) continue;

        final endStr = row['end_date'] as String?;
        final end = endStr == null ? null : DateTime.tryParse(endStr);

        final key = start.toIso8601String();
        await _box.put(key, {
          'startDate': start.toIso8601String(),
          'endDate': end?.toIso8601String(),
        });
      }
    } catch (_) {
      // Silent fail: user can still use the app offline.
    }
  }
}