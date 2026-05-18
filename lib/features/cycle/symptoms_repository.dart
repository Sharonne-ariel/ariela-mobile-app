import 'package:hive_flutter/hive_flutter.dart';

import '../../main.dart';
import 'symptoms_screen.dart';

/// Local-first repository for symptom logs with optional cloud sync.
class SymptomsRepository {
  SymptomsRepository._();
  static final instance = SymptomsRepository._();

  Box get _box => Hive.box<dynamic>('symptoms');

  String _keyForDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> saveForDate(DateTime date, Set<Symptom> symptoms) async {
    final key = _keyForDate(date);
    final names = symptoms.map((s) => s.name).toList();
    await _box.put(key, names);

    try {
      await _pushToCloud(date, symptoms);
    } catch (_) {
      // Silent fail.
    }
  }

  Set<Symptom> getForDate(DateTime date) {
    final key = _keyForDate(date);
    final raw = _box.get(key);
    if (raw is! List) return {};

    final result = <Symptom>{};
    for (final name in raw) {
      if (name is! String) continue;
      try {
        result.add(Symptom.values.byName(name));
      } catch (_) {}
    }
    return result;
  }

  Future<void> _pushToCloud(DateTime date, Set<Symptom> symptoms) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final dateStr = _keyForDate(date);

    // First delete existing entries for this date, then insert the new set.
    // This avoids managing diffs per-symptom.
    await supabase
        .from('symptoms')
        .delete()
        .eq('user_id', userId)
        .eq('date', dateStr);

    if (symptoms.isEmpty) return;

    final rows = symptoms
        .map((s) => {
              'user_id': userId,
              'date': dateStr,
              'symptom_type': s.name,
              'intensity': 3, // default intensity for now
            })
        .toList();

    await supabase.from('symptoms').insert(rows);
  }

  Future<void> syncFromCloud() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final rows = await supabase
          .from('symptoms')
          .select()
          .eq('user_id', userId);

      // Group by date
      final byDate = <String, Set<String>>{};
      for (final row in rows as List) {
        if (row is! Map) continue;
        final dateStr = row['date'] as String?;
        final type = row['symptom_type'] as String?;
        if (dateStr == null || type == null) continue;
        byDate.putIfAbsent(dateStr, () => {}).add(type);
      }

      for (final entry in byDate.entries) {
        await _box.put(entry.key, entry.value.toList());
      }
    } catch (_) {
      // Silent fail.
    }
  }
  /// Returns all symptoms logged on dates between [start] and [end] (inclusive).
  /// Result is a map: date → set of symptoms.
  Map<DateTime, Set<Symptom>> getForRange(DateTime start, DateTime end) {
    final result = <DateTime, Set<Symptom>>{};

    // Normalize to date-only.
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);

    for (var day = s;
        !day.isAfter(e);
        day = day.add(const Duration(days: 1))) {
      final symptoms = getForDate(day);
      if (symptoms.isNotEmpty) {
        result[day] = symptoms;
      }
    }
    return result;
  }
}