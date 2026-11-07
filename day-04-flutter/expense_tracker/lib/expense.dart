enum ExpenseCategory { food, transport, shopping, bills, entertainment, other }

extension ExpenseCategoryLabel on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.bills:
        return 'Bills';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.other:
        return 'Other';
    }
  }
}

class Expense {
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
}

// Total of a list of expenses.
double totalSpent(List<Expense> expenses) {
  return expenses.fold(0, (sum, expense) => sum + expense.amount);
}

// Total spent per category, only including categories that have expenses.
Map<ExpenseCategory, double> totalsByCategory(List<Expense> expenses) {
  final totals = <ExpenseCategory, double>{};
  for (final expense in expenses) {
    totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
  }
  return totals;
}

// Expenses from one calendar month.
List<Expense> expensesInMonth(List<Expense> expenses, int year, int month) {
  return expenses
      .where((e) => e.date.year == year && e.date.month == month)
      .toList();
}
