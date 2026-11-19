import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Habit sampleHabit({List<DateTime>? doneDays}) {
  final habit = Habit(
    id: '1',
    name: 'Read',
    color: 0xFF2E7D5B,
    targetDays: 5,
    created: DateTime(2026, 11, 1),
  );
  for (final day in doneDays ?? []) {
    habit.toggle(day);
  }
  return habit;
}

void main() {
  testWidgets('empty state shows when there are no habits', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const HabitTrackerApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('No habits yet'), findsOneWidget);
    expect(find.text('Habit Tracker'), findsOneWidget);
  });

  testWidgets('a saved habit shows with its streak', (
    WidgetTester tester,
  ) async {
    final today = DateTime.now();
    final habit = sampleHabit(
      doneDays: [today, today.subtract(const Duration(days: 1))],
    );
    SharedPreferences.setMockInitialValues({
      'habits': Habit.encodeList([habit]),
    });
    await tester.pumpWidget(const HabitTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('Read'), findsOneWidget);
    expect(find.text('2 day streak'), findsOneWidget);
    expect(find.text('Today: 1 of 1 done'), findsOneWidget);
  });

  testWidgets('tapping the circle marks today done', (
    WidgetTester tester,
  ) async {
    final habit = sampleHabit();
    SharedPreferences.setMockInitialValues({
      'habits': Habit.encodeList([habit]),
    });
    await tester.pumpWidget(const HabitTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('Today: 0 of 1 done'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.radio_button_unchecked));
    await tester.pumpAndSettle();

    expect(find.text('Today: 1 of 1 done'), findsOneWidget);
    expect(find.text('1 day streak'), findsOneWidget);
  });

  testWidgets('the add button opens the new habit dialog', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const HabitTrackerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add habit'));
    await tester.pumpAndSettle();

    expect(find.text('New habit'), findsOneWidget);
    expect(find.text('Habit name'), findsOneWidget);
    expect(find.text('Target days per week'), findsOneWidget);
  });
}
