import 'dart:convert';

enum TaskPriority { low, medium, high }

extension TaskPriorityLabel on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

class Task {
  Task({
    required this.id,
    required this.title,
    this.done = false,
    this.priority = TaskPriority.medium,
    this.dueDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String title;
  final bool done;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime createdAt;

  Task copyWith({bool? done}) {
    return Task(
      id: id,
      title: title,
      done: done ?? this.done,
      priority: priority,
      dueDate: dueDate,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done,
      'priority': priority.name,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool? ?? false,
      priority: TaskPriority.values.byName(
        json['priority'] as String? ?? 'medium',
      ),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

// Encode a task list to a single string for storage.
String encodeTasks(List<Task> tasks) {
  return jsonEncode(tasks.map((task) => task.toJson()).toList());
}

List<Task> decodeTasks(String raw) {
  final decoded = jsonDecode(raw) as List;
  return decoded
      .map((item) => Task.fromJson(item as Map<String, dynamic>))
      .toList();
}

enum TaskFilter { all, active, done }

List<Task> filteredTasks(List<Task> tasks, TaskFilter filter) {
  switch (filter) {
    case TaskFilter.all:
      return List.of(tasks);
    case TaskFilter.active:
      return tasks.where((task) => !task.done).toList();
    case TaskFilter.done:
      return tasks.where((task) => task.done).toList();
  }
}

// Tasks sorted with overdue and high priority first, done tasks last.
List<Task> sortedTasks(List<Task> tasks) {
  final sorted = List<Task>.of(tasks);
  sorted.sort((a, b) {
    if (a.done != b.done) return a.done ? 1 : -1;
    final priorityOrder = b.priority.index.compareTo(a.priority.index);
    if (priorityOrder != 0) return priorityOrder;
    return b.createdAt.compareTo(a.createdAt);
  });
  return sorted;
}

int remainingCount(List<Task> tasks) {
  return tasks.where((task) => !task.done).length;
}

bool isOverdue(Task task, DateTime now) {
  if (task.done || task.dueDate == null) return false;
  final due = task.dueDate!;
  return DateTime(
    due.year,
    due.month,
    due.day,
  ).isBefore(DateTime(now.year, now.month, now.day));
}
