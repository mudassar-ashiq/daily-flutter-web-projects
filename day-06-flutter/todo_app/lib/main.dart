import 'package:flutter/material.dart';

import 'task.dart';
import 'task_store.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  TaskStore? _store;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final store = await TaskStore.load();
    setState(() {
      _store = store;
      _tasks = store.loadTasks();
      _loading = false;
    });
  }

  Future<void> _save() async {
    await _store?.saveTasks(_tasks);
  }

  void _addTask(String title, TaskPriority priority, DateTime? dueDate) {
    setState(() {
      _tasks.insert(
        0,
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          priority: priority,
          dueDate: dueDate,
        ),
      );
    });
    _save();
  }

  void _toggleTask(Task task) {
    setState(() {
      _tasks = _tasks
          .map((t) => t.id == task.id ? t.copyWith(done: !t.done) : t)
          .toList();
    });
    _save();
  }

  void _deleteTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    setState(() => _tasks.removeAt(index));
    _save();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() => _tasks.insert(index, task));
            _save();
          },
        ),
      ),
    );
  }

  void _clearDone() {
    setState(() => _tasks.removeWhere((task) => task.done));
    _save();
  }

  void _showAddSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTaskSheet(onAdd: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = sortedTasks(filteredTasks(_tasks, _filter));
    final done = _tasks.length - remainingCount(_tasks);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do'),
        actions: [
          if (done > 0)
            TextButton(onPressed: _clearDone, child: const Text('Clear done')),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _ProgressHeader(done: done, total: _tasks.length),
                _FilterRow(
                  filter: _filter,
                  onChanged: (filter) => setState(() => _filter = filter),
                ),
                Expanded(
                  child: visible.isEmpty
                      ? _EmptyState(filter: _filter)
                      : ListView.builder(
                          itemCount: visible.length,
                          itemBuilder: (context, index) {
                            final task = visible[index];
                            return Dismissible(
                              key: ValueKey(task.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red.shade400,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) => _deleteTask(task),
                              child: TaskTile(
                                task: task,
                                onToggle: () => _toggleTask(task),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSheet,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            total == 0 ? 'No tasks yet' : '$done of $total done',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.filter, required this.onChanged});

  final TaskFilter filter;
  final ValueChanged<TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (final entry in const {
            TaskFilter.all: 'All',
            TaskFilter.active: 'Active',
            TaskFilter.done: 'Done',
          }.entries)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(entry.value),
                selected: filter == entry.key,
                onSelected: (_) => onChanged(entry.key),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});

  final TaskFilter filter;

  @override
  Widget build(BuildContext context) {
    final text = switch (filter) {
      TaskFilter.all => 'Nothing here yet.\nTap + to add your first task.',
      TaskFilter.active => 'No active tasks. Nice work.',
      TaskFilter.done => 'No finished tasks yet.',
    };
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: Colors.grey.shade600),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onToggle});

  final Task task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final overdue = isOverdue(task, DateTime.now());
    return ListTile(
      leading: Checkbox(value: task.done, onChanged: (_) => onToggle()),
      title: Text(
        task.title,
        style: task.done
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: Row(
        children: [
          _PriorityTag(priority: task.priority),
          if (task.dueDate != null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.event,
              size: 14,
              color: overdue ? Colors.red : Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              _dueLabel(task.dueDate!),
              style: TextStyle(
                color: overdue ? Colors.red : Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
      onTap: onToggle,
    );
  }

  String _dueLabel(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _PriorityTag extends StatelessWidget {
  const _PriorityTag({required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      TaskPriority.high => Colors.red.shade700,
      TaskPriority.medium => Colors.amber.shade800,
      TaskPriority.low => Colors.green.shade700,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(priority.label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key, required this.onAdd});

  final void Function(String title, TaskPriority priority, DateTime? dueDate)
  onAdd;

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(_controller.text.trim(), _priority, _dueDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New task', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextFormField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'What needs doing?',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a task first';
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            SegmentedButton<TaskPriority>(
              segments: const [
                ButtonSegment(value: TaskPriority.low, label: Text('Low')),
                ButtonSegment(
                  value: TaskPriority.medium,
                  label: Text('Medium'),
                ),
                ButtonSegment(value: TaskPriority.high, label: Text('High')),
              ],
              selected: {_priority},
              onSelectionChanged: (selected) {
                setState(() => _priority = selected.first);
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _pickDueDate,
                  icon: const Icon(Icons.event),
                  label: Text(
                    _dueDate == null
                        ? 'Add due date'
                        : 'Due ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                  ),
                ),
                if (_dueDate != null)
                  TextButton(
                    onPressed: () => setState(() => _dueDate = null),
                    child: const Text('Remove'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Add task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
