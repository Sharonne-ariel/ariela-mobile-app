import 'package:hive_flutter/hive_flutter.dart';

import '../../main.dart';

/// Local-first repository for daily journal notes with cloud sync.
class NotesRepository {
  NotesRepository._();
  static final instance = NotesRepository._();

  Box get _box => Hive.box<dynamic>('symptoms'); // reuse box

  String _keyForDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return 'note:$y-$m-$d';
  }

  String _dateOnly(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Get the note for a given day (empty string if none).
  String getForDate(DateTime date) {
    final raw = _box.get(_keyForDate(date));
    return raw is String ? raw : '';
  }

  /// Save (or update) the note for a day. Empty string deletes it.
  Future<void> saveForDate(DateTime date, String note) async {
    final key = _keyForDate(date);
    if (note.trim().isEmpty) {
      await _box.delete(key);
    } else {
      await _box.put(key, note.trim());
    }

    try {
      await _pushToCloud(date, note.trim());
    } catch (_) {}
  }

  Future<void> _pushToCloud(DateTime date, String note) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final dateStr = _dateOnly(date);

    if (note.isEmpty) {
      await supabase
          .from('daily_notes')
          .delete()
          .eq('user_id', userId)
          .eq('date', dateStr);
      return;
    }

    await supabase.from('daily_notes').upsert({
      'user_id': userId,
      'date': dateStr,
      'note': note,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id,date');
  }

  /// Pull all cloud notes down into Hive.
  Future<void> syncFromCloud() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final rows = await supabase
          .from('daily_notes')
          .select()
          .eq('user_id', userId);

      for (final row in rows as List) {
        if (row is! Map) continue;
        final dateStr = row['date'] as String?;
        final note = row['note'] as String?;
        if (dateStr == null || note == null) continue;
        await _box.put('note:$dateStr', note);
      }
    } catch (_) {}
  }

  /// Returns all notes in a date range. Map: date → note text.
  Map<DateTime, String> getForRange(DateTime start, DateTime end) {
    final result = <DateTime, String>{};
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);

    for (var day = s;
        !day.isAfter(e);
        day = day.add(const Duration(days: 1))) {
      final note = getForDate(day);
      if (note.isNotEmpty) {
        result[day] = note;
      }
    }
    return result;
  }
}