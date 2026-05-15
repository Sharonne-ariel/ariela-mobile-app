import 'package:hive_flutter/hive_flutter.dart';

import '../../features/cycle/symptoms_screen.dart';

/// Local-only repository for symptom logs.
///
/// Each entry is stored under a key built from the date, so logging twice on
/// the same day overwrites the previous selection.
class SymptomsRepository {
  SymptomsRepository._();
  static final instance = SymptomsRepository._();

  Box get _box => Hive.box<dynamic>('symptoms');

  /// Key format: `YYYY-MM-DD`
  String _keyForDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Save the set of selected symptoms for the given day.
  Future<void> saveForDate(DateTime date, Set<Symptom> symptoms) async {
    final key = _keyForDate(date);
    final names = symptoms.map((s) => s.name).toList();
    await _box.put(key, names);
  }

  /// Returns the symptoms logged for the given day (empty if none).
  Set<Symptom> getForDate(DateTime date) {
    final key = _keyForDate(date);
    final raw = _box.get(key);
    if (raw is! List) return {};

    final result = <Symptom>{};
    for (final name in raw) {
      if (name is! String) continue;
      try {
        result.add(Symptom.values.byName(name));
      } catch (_) {
        // Unknown symptom name (e.g. removed in a later version) — ignore.
      }
    }
    return result;
  }
}