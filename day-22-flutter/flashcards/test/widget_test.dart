import 'package:flashcards/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('deck list shows the starter decks', (tester) async {
    await tester.pumpWidget(const FlashcardsApp());
    await tester.pumpAndSettle();

    expect(find.text('My flashcards'), findsOneWidget);
    expect(find.text('Flutter basics'), findsOneWidget);
    expect(find.text('English words'), findsOneWidget);
    expect(find.text('Pakistan GK'), findsOneWidget);
  });

  testWidgets('tapping a deck opens the study screen', (tester) async {
    await tester.pumpWidget(const FlashcardsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Flutter basics'));
    await tester.pumpAndSettle();

    expect(find.text('Card 1 of 5'), findsOneWidget);
    expect(find.text('What is a Widget in Flutter?'), findsOneWidget);
  });

  testWidgets('tapping the card shows the answer', (tester) async {
    await tester.pumpWidget(const FlashcardsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Flutter basics'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('What is a Widget in Flutter?'));
    await tester.pump();

    expect(find.text('Answer'), findsOneWidget);
    expect(
      find.textContaining('Everything in Flutter is a widget'),
      findsOneWidget,
    );
  });

  testWidgets('add deck dialog adds a deck to the list', (tester) async {
    await tester.pumpWidget(const FlashcardsApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Biology terms');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Biology terms'), findsOneWidget);
  });
}
