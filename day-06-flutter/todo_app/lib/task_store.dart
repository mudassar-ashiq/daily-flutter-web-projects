import 'package:shared_preferences/shared_preferences.dart';

import 'task.dart';

const _tasksKey = 'tasks';

// Small wrapper around SharedPreferences so the UI never touches storage
// directly, and tests can pass in mock preferences.
class TaskStore {
  TaskStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<TaskStore> load() async {
    return TaskStore(await SharedPreferences.getInstance());
  }

  List<Task> loadTasks() {
    final raw = _prefs.getString(_tasksKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return decodeTasks(raw);
    } on FormatException {
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    await _prefs.setString(_tasksKey, encodeTasks(tasks));
  }
}
