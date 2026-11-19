import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/habit_store.dart';

const _habitColors = [
  Color(0xFF2E7D5B),
  Color(0xFF1565C0),
  Color(0xFF6A4FBF),
  Color(0xFFC2571B),
  Color(0xFF8E24AA),
  Color(0xFF00838F),
];

const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.store});

  final HabitStore? store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HabitStore _store;
  List<Habit> _habits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _store = widget.store ?? HabitStore();
    _load();
  }

  Future<void> _load() async {
    final habits = await _store.load();
    if (!mounted) return;
    setState(() {
      _habits = habits;
      _loading = false;
    });
  }

  Future<void> _save() => _store.save(_habits);

  void _toggleToday(Habit habit) {
    setState(() => habit.toggle(DateTime.now()));
    _save();
  }

  void _deleteHabit(Habit habit) {
    final index = _habits.indexOf(habit);
    setState(() => _habits.remove(habit));
    _save();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${habit.name} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() => _habits.insert(index, habit));
            _save();
          },
        ),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    final nameController = TextEditingController();
    var color = _habitColors.first.toARGB32();
    var targetDays = 5;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New habit'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Habit name',
                      hintText: 'e.g. Read 20 pages',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Colour'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (final c in _habitColors)
                        GestureDetector(
                          onTap: () =>
                              setDialogState(() => color = c.toARGB32()),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: c,
                            child: color == c.toARGB32()
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Target days per week'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: targetDays > 1
                                ? () => setDialogState(() => targetDays--)
                                : null,
                          ),
                          Text('$targetDays'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: targetDays < 7
                                ? () => setDialogState(() => targetDays++)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != true) return;
    final name = nameController.text.trim();
    if (name.isEmpty) return;
    if (!mounted) return;

    setState(() {
      _habits.add(
        Habit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          color: color,
          targetDays: targetDays,
          created: DateTime.now(),
        ),
      );
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final doneToday = _habits.where((h) => h.isDoneOn(today)).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _habits.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No habits yet.\nTap + to add your first one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today: $doneToday of ${_habits.length} done',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: _habits.isEmpty
                              ? 0
                              : doneToday / _habits.length,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                for (final habit in _habits)
                  _HabitCard(
                    habit: habit,
                    onToggleToday: () => _toggleToday(habit),
                    onDelete: () => _deleteHabit(habit),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Add habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.habit,
    required this.onToggleToday,
    required this.onDelete,
  });

  final Habit habit;
  final VoidCallback onToggleToday;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = Color(habit.color);
    final today = DateTime.now();
    final doneToday = habit.isDoneOn(today);
    final streak = habit.currentStreak();
    final week = Habit.weekDates();
    final doneThisWeek = habit.doneThisWeek();

    return Dismissible(
      key: ValueKey(habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 6, backgroundColor: color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      habit.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: onToggleToday,
                    tooltip: doneToday
                        ? 'Mark today as not done'
                        : 'Mark today done',
                    icon: Icon(
                      doneToday
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: doneToday ? color : null,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                streak == 0 ? 'No streak yet' : '$streak day streak',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (var i = 0; i < 7; i++)
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            _weekdayLabels[i],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: habit.isDoneOn(week[i])
                                ? color
                                : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                            child: habit.isDoneOn(week[i])
                                ? const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    '$doneThisWeek/${habit.targetDays} this week',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
