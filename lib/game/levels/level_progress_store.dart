import 'package:shared_preferences/shared_preferences.dart';

/// Persists per-level star ratings across app restarts, per CLAUDE.md's
/// "Состояние уровня/прогресса — SharedPreferences" plan. A level's unlock
/// state isn't stored separately — [buildLevels] derives it from whether
/// the previous level has stars.
class LevelProgressStore {
  LevelProgressStore._();

  static String _key(int level) => 'level_stars_$level';

  static Future<Map<int, int>> loadStars(int levelCount) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (var number = 1; number <= levelCount; number++)
        number: prefs.getInt(_key(number)) ?? 0,
    };
  }

  // Never overwrites a better previous result with a worse one.
  static Future<void> saveStars(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_key(level)) ?? 0;
    if (stars > current) {
      await prefs.setInt(_key(level), stars);
    }
  }
}
