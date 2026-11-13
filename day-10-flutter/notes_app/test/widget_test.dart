import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the empty state when there are no notes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NotesApp());
    await tester.pumpAndSettle();

    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('No notes yet. Tap + to write one.'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('adding a note shows it in the list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Exam revision');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Revise chapter 4 tonight',
    );
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Exam revision'), findsOneWidget);
    expect(find.textContaining('Revise chapter 4'), findsOneWidget);
  });

  testWidgets('search filters the list', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'notes': '[{"id":"1","title":"Flutter","body":"widgets","createdAt":"2026-11-13T09:00:00.000","updatedAt":"2026-11-13T09:00:00.000","pinned":false},{"id":"2","title":"Groceries","body":"buy milk","createdAt":"2026-11-13T09:00:00.000","updatedAt":"2026-11-13T09:00:00.000","pinned":false}]',
    });
    await tester.pumpWidget(const NotesApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'milk');
    await tester.pumpAndSettle();

    expect(find.text('Flutter'), findsNothing);
    expect(find.text('Groceries'), findsOneWidget);
  });
}
