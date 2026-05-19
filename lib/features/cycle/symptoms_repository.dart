import 'package:hive_flutter/hive_flutter.dart';

import '../../main.dart';
import 'symptoms_screen.dart';

/// A logged symptom with its intensity (1=mild, 3=moderate, 5=strong).
class SymptomLog {
  const SymptomLog({required this.symptom, required this.intensity});

  final Symptom symptom;
  final int intensity;

  Map<String, dynamic> toMap() => {
        'symptom': symptom.name,
        'intensity': intensity,
      };

  static SymptomLog? fromMap(Map raw) {
    final name = raw['symptom'] as String?;
    final intensity = raw['intensity'] as int? ?? 3;
    if (name == null) return null;
    try {
      return SymptomLog(
        symptom: Symptom.values.byName(name),
        intensity: intensity,
      );
    } catch (_) {
      return null;
    }
  }
}

/// Local-first repository for symptom logs with cloud sync.
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

  /// Save the set of logged symptoms (with intensity) for the given day.
  Future<void> saveForDate(DateTime date, List<SymptomLog> logs) async {
    final key = _keyForDate(date);
    final encoded = logs.map((l) => l.toMap()).toList();
    await _box.put(key, encoded);

    try {
      await _pushToCloud(date, logs);
    } catch (_) {
      // Silent fail.
    }
  }

  /// Returns the symptoms logged for the given day.
  List<SymptomLog> getForDate(DateTime date) {
    final key = _keyForDate(date);
    final raw = _box.get(key);
    if (raw is! List) return [];

    final result = <SymptomLog>[];
    for (final entry in raw) {
      // Backward compat: old format was just a list of names (strings).
      if (entry is String) {
        try {
          result.add(SymptomLog(
            symptom: Symptom.values.byName(entry),
            intensity: 3,
          ));
        } catch (_) {}
      } else if (entry is Map) {
        final log = SymptomLog.fromMap(entry);
        if (log != null) result.add(log);
      }
    }
    return result;
  }

  /// Returns just the symptoms (no intensity) — convenience for existing UI.
  Set<Symptom> getSymptomsForDate(DateTime date) =>
      getForDate(date).map((l) => l.symptom).toSet();

  /// Returns symptoms in a date range. Map: date → list of logs.
  Map<DateTime, List<SymptomLog>> getForRange(DateTime start, DateTime end) {
    final result = <DateTime, List<SymptomLog>>{};
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);

    for (var day = s;
        !day.isAfter(e);
        day = day.add(const Duration(days: 1))) {
      final logs = getForDate(day);
      if (logs.isNotEmpty) {
        result[day] = logs;
      }
    }
    return result;
  }

  Future<void> _pushToCloud(
      DateTime date, List<SymptomLog> logs) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final dateStr = _keyForDate(date);

    await supabase
        .from('symptoms')
        .delete()
        .eq('user_id', userId)
        .eq('date', dateStr);

    if (logs.isEmpty) return;

    final rows = logs
        .map((l) => {
              'user_id': userId,
              'date': dateStr,
              'symptom_type': l.symptom.name,
              'intensity': l.intensity,
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

      // Group by date → list of logs
      final byDate = <String, List<Map<String, dynamic>>>{};
      for (final row in rows as List) {
        if (row is! Map) continue;
        final dateStr = row['date'] as String?;
        final type = row['symptom_type'] as String?;
        final intensity = row['intensity'] as int? ?? 3;
        if (dateStr == null || type == null) continue;
        byDate.putIfAbsent(dateStr, () => []).add({
          'symptom': type,
          'intensity': intensity,
        });
      }

      for (final entry in byDate.entries) {
        await _box.put(entry.key, entry.value);
      }
    } catch (_) {}
  }
}