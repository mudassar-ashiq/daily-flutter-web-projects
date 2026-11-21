import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('home screen lists the built-in recipes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RecipeBookApp());
    await tester.pumpAndSettle();

    expect(find.text('Chicken Biryani'), findsOneWidget);
    expect(find.text('Chicken Karahi'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Mango Lassi'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Mango Lassi'), findsOneWidget);
  });

  testWidgets('search narrows the list by name', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeBookApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'karahi');
    await tester.pumpAndSettle();

    expect(find.text('Chicken Karahi'), findsOneWidget);
    expect(find.text('Chicken Biryani'), findsNothing);
  });

  testWidgets('search also matches an ingredient', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeBookApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'cocoa');
    await tester.pumpAndSettle();

    expect(find.text('Chocolate Cake'), findsOneWidget);
    expect(find.text('Chicken Biryani'), findsNothing);
  });

  testWidgets('tapping the heart marks a recipe as favourite', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RecipeBookApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('tapping a recipe opens its detail page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RecipeBookApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chicken Biryani'));
    await tester.pumpAndSettle();

    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('750 g chicken, cut into pieces'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Method'), 300);
    expect(find.text('Method'), findsOneWidget);
  });
}
