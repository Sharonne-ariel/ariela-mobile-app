import 'package:hive_flutter/hive_flutter.dart';

import 'cycle_data.dart';

/// Local-only repository for period entries.
///
/// Stores periods as simple maps in a Hive box. Later we'll sync these
/// to Supabase, but for MVP this is enough to keep data across app restarts.
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

  /// Returns the most recent period (or null if none).
  PeriodEntry? getCurrent() {
    final all = getAll();
    return all.isEmpty ? null : all.first;
  }

  /// Saves or updates a period. Uses startDate's ISO string as key.
  Future<void> save(PeriodEntry entry) async {
    final key = entry.startDate.toIso8601String();
    await _box.put(key, {
      'startDate': entry.startDate.toIso8601String(),
      'endDate': entry.endDate?.toIso8601String(),
    });
  }
}