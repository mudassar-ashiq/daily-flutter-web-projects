import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/task.dart';
import 'package:todo_app/task_store.dart';

void main() {
  group('Task json', () {
    test('round trip keeps title, priority and due date', () {
      final task = Task(
        id: '1',
        title: 'Buy milk',
        priority: TaskPriority.high,
        dueDate: DateTime(2026, 11, 10),
      );
      final restored = Task.fromJson(task.toJson());
      expect(restored.title, 'Buy milk');
      expect(restored.priority, TaskPriority.high);
      expect(restored.dueDate, DateTime(2026, 11, 10));
      expect(restored.done, isFalse);
    });

    test('encode and decode a list', () {
      final tasks = [
        Task(id: '1', title: 'One'),
        Task(id: '2', title: 'Two', done: true),
      ];
      final restored = decodeTasks(encodeTasks(tasks));
      expect(restored.length, 2);
      expect(restored[1].done, isTrue);
    });
  });

  group('filters and counts', () {
    final tasks = [
      Task(id: '1', title: 'One'),
      Task(id: '2', title: 'Two', done: true),
      Task(id: '3', title: 'Three'),
    ];

    test('remaining count ignores done tasks', () {
      expect(remainingCount(tasks), 2);
    });

    test('active filter hides done tasks', () {
      expect(filteredTasks(tasks, TaskFilter.active).length, 2);
    });

    test('done filter only shows done tasks', () {
      final done = filteredTasks(tasks, TaskFilter.done);
      expect(done.length, 1);
      expect(done.first.title, 'Two');
    });

    test('overdue means a past due date on an open task', () {
      final overdue = Task(
        id: '4',
        title: 'Late',
        dueDate: DateTime(2026, 11, 1),
      );
      expect(isOverdue(overdue, DateTime(2026, 11, 9)), isTrue);
      expect(
        isOverdue(overdue.copyWith(done: true), DateTime(2026, 11, 9)),
        isFalse,
      );
    });
  });

  group('TaskStore', () {
    test('saves and loads tasks from preferences', () async {
      SharedPreferences.setMockInitialValues({});
      final store = TaskStore(await SharedPreferences.getInstance());
      await store.saveTasks([Task(id: '1', title: 'Saved task')]);

      final reloaded = TaskStore(await SharedPreferences.getInstance());
      final tasks = reloaded.loadTasks();
      expect(tasks.length, 1);
      expect(tasks.first.title, 'Saved task');
    });
  });

  testWidgets('adding a task shows it in the list', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField),
      'Finish SE3233 assignment',
    );
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    expect(find.text('Finish SE3233 assignment'), findsOneWidget);
    expect(find.text('0 of 1 done'), findsOneWidget);
  });

  testWidgets('ticking a task marks it done', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Read chapter 4');
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(find.text('1 of 1 done'), findsOneWidget);
  });
}
