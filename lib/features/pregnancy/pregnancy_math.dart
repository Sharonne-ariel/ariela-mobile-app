import 'package:flutter/material.dart';

/// Pure math helpers for pregnancy tracking.
///
/// Standard pregnancy duration: 40 weeks (280 days) from last period start.
/// Or 38 weeks (266 days) from conception.
class PregnancyMath {
  PregnancyMath._();

  static const int totalDays = 280;
  static const int totalWeeks = 40;

  /// Days since pregnancy started (computed from last period start).
  static int daysSinceStart(DateTime lastPeriodStart, [DateTime? today]) {
    final now = today ?? DateTime.now();
    final t = DateTime(now.year, now.month, now.day);
    final s = DateTime(
        lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    return t.difference(s).inDays;
  }

  /// Current pregnancy week (1-40+).
  static int currentWeek(DateTime lastPeriodStart, [DateTime? today]) {
    final days = daysSinceStart(lastPeriodStart, today);
    return (days ~/ 7) + 1;
  }

  /// Day within the current week (1-7).
  static int dayOfWeek(DateTime lastPeriodStart, [DateTime? today]) {
    final days = daysSinceStart(lastPeriodStart, today);
    return (days % 7) + 1;
  }

  /// Trimester number (1, 2, or 3).
  static int trimester(int week) {
    if (week <= 13) return 1;
    if (week <= 27) return 2;
    return 3;
  }

  /// Days until due date.
  static int daysUntilDue(DateTime dueDate, [DateTime? today]) {
    final now = today ?? DateTime.now();
    final t = DateTime(now.year, now.month, now.day);
    final d = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return d.difference(t).inDays;
  }

  /// Compute due date from last period start (40 weeks later).
  static DateTime dueDateFromLastPeriod(DateTime lastPeriodStart) {
    return lastPeriodStart.add(const Duration(days: totalDays));
  }

  /// Compute last period start from due date (40 weeks earlier).
  static DateTime lastPeriodFromDueDate(DateTime dueDate) {
    return dueDate.subtract(const Duration(days: totalDays));
  }

  /// Progress 0.0 to 1.0.
  static double progress(DateTime lastPeriodStart, [DateTime? today]) {
    final days = daysSinceStart(lastPeriodStart, today);
    return (days / totalDays).clamp(0.0, 1.0);
  }

  /// Friendly "baby size" comparison by week.
  /// Approximations used by mainstream pregnancy apps.
  static String babySizeComparison(int week) {
    if (week < 5) return '—';
    if (week == 5) return 'sesame seed';
    if (week == 6) return 'lentil';
    if (week == 7) return 'blueberry';
    if (week == 8) return 'raspberry';
    if (week == 9) return 'cherry';
    if (week == 10) return 'strawberry';
    if (week == 11) return 'lime';
    if (week == 12) return 'plum';
    if (week == 13) return 'peach';
    if (week == 14) return 'lemon';
    if (week == 15) return 'apple';
    if (week == 16) return 'avocado';
    if (week == 17) return 'pomegranate';
    if (week == 18) return 'bell pepper';
    if (week == 19) return 'mango';
    if (week == 20) return 'banana';
    if (week == 21) return 'carrot';
    if (week == 22) return 'papaya';
    if (week == 23) return 'grapefruit';
    if (week == 24) return 'cantaloupe';
    if (week == 25) return 'cauliflower';
    if (week == 26) return 'lettuce';
    if (week == 27) return 'rutabaga';
    if (week == 28) return 'eggplant';
    if (week == 29) return 'butternut squash';
    if (week == 30) return 'cabbage';
    if (week == 31) return 'coconut';
    if (week == 32) return 'jicama';
    if (week == 33) return 'pineapple';
    if (week == 34) return 'cantaloupe';
    if (week == 35) return 'honeydew melon';
    if (week == 36) return 'romaine lettuce';
    if (week == 37) return 'Swiss chard';
    if (week == 38) return 'leek';
    if (week == 39) return 'mini watermelon';
    return 'watermelon';
  }

  /// Friendly French version.
  static String babySizeComparisonFr(int week) {
    if (week < 5) return '—';
    if (week == 5) return 'graine de sésame';
    if (week == 6) return 'lentille';
    if (week == 7) return 'myrtille';
    if (week == 8) return 'framboise';
    if (week == 9) return 'cerise';
    if (week == 10) return 'fraise';
    if (week == 11) return 'citron vert';
    if (week == 12) return 'prune';
    if (week == 13) return 'pêche';
    if (week == 14) return 'citron';
    if (week == 15) return 'pomme';
    if (week == 16) return 'avocat';
    if (week == 17) return 'grenade';
    if (week == 18) return 'poivron';
    if (week == 19) return 'mangue';
    if (week == 20) return 'banane';
    if (week == 21) return 'carotte';
    if (week == 22) return 'papaye';
    if (week == 23) return 'pamplemousse';
    if (week == 24) return 'melon';
    if (week == 25) return 'chou-fleur';
    if (week == 26) return 'laitue';
    if (week == 27) return 'rutabaga';
    if (week == 28) return 'aubergine';
    if (week == 29) return 'courge musquée';
    if (week == 30) return 'chou';
    if (week == 31) return 'noix de coco';
    if (week == 32) return 'jicama';
    if (week == 33) return 'ananas';
    if (week == 34) return 'cantaloup';
    if (week == 35) return 'pastèque (petite)';
    if (week == 36) return 'romaine';
    if (week == 37) return 'bette à carde';
    if (week == 38) return 'poireau';
    if (week == 39) return 'petite pastèque';
    return 'pastèque';
  }

  /// Returns colors associated with a trimester for UI accents.
  static Color trimesterColor(int trimester) {
    return switch (trimester) {
      1 => const Color(0xFFF9D4E1), // soft pink
      2 => const Color(0xFFD9D3F5), // soft lavender
      _ => const Color(0xFF9FE1CB), // soft mint
    };
  }
}