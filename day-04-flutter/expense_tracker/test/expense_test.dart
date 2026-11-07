import 'package:expense_tracker/expense.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('totals', () {
    final expenses = [
      Expense(
        id: '1',
        title: 'Groceries',
        amount: 2000,
        category: ExpenseCategory.food,
        date: DateTime(2026, 11, 3),
      ),
      Expense(
        id: '2',
        title: 'Bus fare',
        amount: 150,
        category: ExpenseCategory.transport,
        date: DateTime(2026, 11, 4),
      ),
      Expense(
        id: '3',
        title: 'Snacks',
        amount: 300,
        category: ExpenseCategory.food,
        date: DateTime(2026, 10, 20),
      ),
    ];

    test('totalSpent adds up all amounts', () {
      expect(totalSpent(expenses), 2450);
    });

    test('totalSpent is 0 for an empty list', () {
      expect(totalSpent([]), 0);
    });

    test('totalsByCategory groups amounts by category', () {
      final totals = totalsByCategory(expenses);
      expect(totals[ExpenseCategory.food], 2300);
      expect(totals[ExpenseCategory.transport], 150);
      expect(totals.containsKey(ExpenseCategory.bills), isFalse);
    });

    test('expensesInMonth keeps only that month', () {
      final november = expensesInMonth(expenses, 2026, 11);
      expect(november.length, 2);
      expect(november.every((e) => e.date.month == 11), isTrue);
    });
  });

  testWidgets('home shows the monthly total and sample expenses', (
    tester,
  ) async {
    await tester.pumpWidget(const ExpenseTrackerApp());

    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('Spent this month'), findsOneWidget);
    expect(find.text('Weekly groceries'), findsOneWidget);
    expect(find.text('Electricity bill'), findsOneWidget);
  });

  testWidgets('adding an expense updates the list', (tester) async {
    await tester.pumpWidget(const ExpenseTrackerApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'What did you spend on?'),
      'Movie ticket',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Amount (Rs)'),
      '800',
    );
    await tester.tap(find.text('Save expense'));
    await tester.pumpAndSettle();

    expect(find.text('Movie ticket'), findsOneWidget);
  });
}
