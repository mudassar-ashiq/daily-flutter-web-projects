import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'sample_workouts.dart';

class WorkoutStore {
  static const _key = 'workouts';

  Future<List<Workout>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return sampleWorkouts();
    try {
      return Workout.decodeList(raw);
    } catch (_) {
      return sampleWorkouts();
    }
  }

  Future<void> save(List<Workout> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Workout.encodeList(workouts));
  }
}
