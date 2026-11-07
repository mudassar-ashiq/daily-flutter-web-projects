import 'package:flutter/material.dart';

import 'expense.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E6B4F)),
        useMaterial3: true,
      ),
      home: const ExpenseHomePage(),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      title: 'Weekly groceries',
      amount: 4500,
      category: ExpenseCategory.food,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: '2',
      title: 'Bus fare',
      amount: 120,
      category: ExpenseCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: '3',
      title: 'Electricity bill',
      amount: 6800,
      category: ExpenseCategory.bills,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<Expense> get _thisMonth {
    final now = DateTime.now();
    return expensesInMonth(_expenses, now.year, now.month);
  }

  void _addExpense(String title, double amount, ExpenseCategory category) {
    setState(() {
      _expenses.add(
        Expense(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          amount: amount,
          category: category,
          date: DateTime.now(),
        ),
      );
    });
  }

  void _removeExpense(Expense expense) {
    setState(() => _expenses.remove(expense));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.title} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => _expenses.add(expense)),
        ),
      ),
    );
  }

  Future<void> _showAddExpenseSheet() async {
    final result =
        await showModalBottomSheet<
          ({String title, double amount, ExpenseCategory category})
        >(
          context: context,
          isScrollControlled: true,
          builder: (context) => const AddExpenseSheet(),
        );
    if (result != null) {
      _addExpense(result.title, result.amount, result.category);
    }
  }

  String _formatAmount(double amount) {
    return 'Rs ${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }

  @override
  Widget build(BuildContext context) {
    final monthTotal = totalSpent(_thisMonth);
    final byCategory = totalsByCategory(_thisMonth);
    final sorted = [..._thisMonth]..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Spent this month'),
                  const SizedBox(height: 4),
                  Text(
                    _formatAmount(monthTotal),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_thisMonth.length} expenses',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('By category', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (byCategory.isEmpty)
            const Text('Nothing spent yet this month.')
          else
            ...byCategory.entries.map((entry) {
              final share = monthTotal == 0 ? 0.0 : entry.value / monthTotal;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key.label),
                        Text(_formatAmount(entry.value)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(value: share),
                  ],
                ),
              );
            }),
          const SizedBox(height: 16),
          Text(
            'Recent expenses',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (sorted.isEmpty)
            const Text('No expenses yet. Tap + to add one.')
          else
            ...sorted.map(
              (expense) => Card(
                child: ListTile(
                  title: Text(expense.title),
                  subtitle: Text(
                    '${expense.category.label} · ${expense.date.day}/${expense.date.month}/${expense.date.year}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_formatAmount(expense.amount)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeExpense(expense),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseSheet,
        tooltip: 'Add expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.food;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop((
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _category,
    ));
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add expense', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'What did you spend on?',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a short description';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (Rs)',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');
                if (amount == null || amount <= 0) {
                  return 'Enter an amount greater than 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ExpenseCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: ExpenseCategory.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _submit, child: const Text('Save expense')),
          ],
        ),
      ),
    );
  }
}
