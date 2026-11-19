import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

/// Saves and loads the habit list with shared_preferences.
class HabitStore {
  static const _key = 'habits';

  Future<List<Habit>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return Habit.decodeList(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Habit.encodeList(habits));
  }
}
