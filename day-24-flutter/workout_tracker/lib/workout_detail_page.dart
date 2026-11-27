import 'package:flutter/material.dart';

import 'models.dart';

class WorkoutDetailPage extends StatefulWidget {
  const WorkoutDetailPage({super.key, required this.workout});

  final Workout workout;

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  late final List<Exercise> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = List.of(widget.workout.exercises);
  }

  double get _volume => _exercises.fold(0, (sum, e) => sum + e.volume);

  Future<void> _addExercise() async {
    final nameController = TextEditingController();
    final setsController = TextEditingController(text: '3');
    final repsController = TextEditingController(text: '10');
    final weightController = TextEditingController(text: '0');

    final result = await showDialog<Exercise>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add exercise'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Exercise',
                  hintText: 'e.g. Bench press',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: setsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Sets'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: repsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Reps'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final sets = int.tryParse(setsController.text) ?? 0;
              final reps = int.tryParse(repsController.text) ?? 0;
              final weight = double.tryParse(weightController.text) ?? 0;
              if (name.isEmpty || sets <= 0 || reps <= 0) return;
              Navigator.of(context).pop(
                Exercise(name: name, sets: sets, reps: reps, weightKg: weight),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result == null) return;
    setState(() => _exercises.add(result));
    widget.workout.exercises.add(result);
  }

  void _deleteExercise(Exercise exercise) {
    setState(() => _exercises.remove(exercise));
    widget.workout.exercises.remove(exercise);
  }

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;
    return Scaffold(
      appBar: AppBar(title: Text(workout.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(label: 'Date', value: formatDate(workout.date)),
                    _Stat(label: 'Exercises', value: '${_exercises.length}'),
                    _Stat(label: 'Volume', value: '${formatKg(_volume)} kg'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _exercises.isEmpty
                ? const Center(
                    child: Text('No exercises yet. Tap + to add one.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _exercises[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.fitness_center),
                          ),
                          title: Text(exercise.name),
                          subtitle: Text(exercise.summary),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${formatKg(exercise.volume)} kg',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _deleteExercise(exercise),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        tooltip: 'Add exercise',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

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
