import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('workout list shows the starter workouts', (tester) async {
    await tester.pumpWidget(const WorkoutTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('My workouts'), findsOneWidget);
    expect(find.text('Chest day'), findsOneWidget);
    expect(find.text('Leg day'), findsOneWidget);
    expect(find.text('Back and arms'), findsOneWidget);
  });

  testWidgets('week summary shows three workouts', (tester) async {
    await tester.pumpWidget(const WorkoutTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('3 workouts'), findsOneWidget);
    expect(find.text('Total lifted'), findsOneWidget);
  });

  testWidgets('tapping a workout opens its detail screen', (tester) async {
    await tester.pumpWidget(const WorkoutTrackerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chest day'));
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsOneWidget);
    expect(find.text('Push-ups'), findsOneWidget);
  });

  testWidgets('add workout dialog adds a workout to the list', (tester) async {
    await tester.pumpWidget(const WorkoutTrackerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Shoulder day');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Shoulder day'), findsOneWidget);
  });
}
