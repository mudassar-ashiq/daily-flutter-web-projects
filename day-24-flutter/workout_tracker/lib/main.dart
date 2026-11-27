import 'package:flutter/material.dart';

import 'models.dart';
import 'workout_detail_page.dart';
import 'workout_store.dart';

void main() {
  runApp(const WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatelessWidget {
  const WorkoutTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const WorkoutListPage(),
    );
  }
}

class WorkoutListPage extends StatefulWidget {
  const WorkoutListPage({super.key});

  @override
  State<WorkoutListPage> createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  final _store = WorkoutStore();
  List<Workout> _workouts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await _store.load();
    workouts.sort((a, b) => b.date.compareTo(a.date));
    if (!mounted) return;
    setState(() {
      _workouts = workouts;
      _loading = false;
    });
  }

  Future<void> _saveWorkouts() async {
    await _store.save(_workouts);
  }

  Future<void> _openWorkout(Workout workout) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WorkoutDetailPage(workout: workout)),
    );
    // Exercises may have changed on the detail screen.
    setState(() {});
    await _saveWorkouts();
  }

  Future<void> _addWorkout() async {
    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New workout'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Workout name',
            hintText: 'e.g. Chest day',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(nameController.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    setState(() {
      _workouts.insert(
        0,
        Workout(name: name, date: DateTime.now(), exercises: []),
      );
    });
    await _saveWorkouts();
  }

  Future<void> _deleteWorkout(Workout workout) async {
    final index = _workouts.indexOf(workout);
    setState(() => _workouts.remove(workout));
    await _saveWorkouts();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${workout.name} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() => _workouts.insert(index, workout));
            await _saveWorkouts();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = weekSummary(_workouts);
    return Scaffold(
      appBar: AppBar(title: const Text('My workouts')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _WeekStat(
                            label: 'This week',
                            value: '${summary.workoutCount} workouts',
                          ),
                          _WeekStat(
                            label: 'Total lifted',
                            value: '${formatKg(summary.volume)} kg',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _workouts.isEmpty
                      ? const Center(
                          child: Text(
                            'No workouts yet. Tap + to log your first one.',
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _workouts.length,
                          itemBuilder: (context, index) {
                            final workout = _workouts[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.fitness_center),
                                ),
                                title: Text(workout.name),
                                subtitle: Text(
                                  '${formatDate(workout.date)}  •  '
                                  '${workout.exercises.length} exercises  •  '
                                  '${workout.totalSets} sets',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${formatKg(workout.volume)} kg',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => _deleteWorkout(workout),
                                    ),
                                  ],
                                ),
                                onTap: () => _openWorkout(workout),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWorkout,
        tooltip: 'New workout',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _WeekStat extends StatelessWidget {
  const _WeekStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
