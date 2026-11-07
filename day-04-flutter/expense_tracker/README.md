# Expense Tracker

A simple expense tracker. Add what you spent, pick a category, and it shows
your total for the month, a breakdown by category, and a list of recent
expenses. You can delete an expense, and undo the delete from the message
that appears at the bottom.

It starts with three sample expenses so the screens are not empty.

## Features

- Add an expense with a description, amount and category
- Monthly total and expense count
- Spending by category with a simple bar for each one
- Recent expenses, newest first
- Delete with undo

## How to run it

```
flutter pub get
flutter run
```

## What I practised

- Keeping the calculation logic in a separate file (`lib/expense.dart`)
- Form validation with a `Form` and a bottom sheet
- State updates with `setState` and a SnackBar action for undo
- Unit tests for the totals and a widget test for adding an expense

Amounts are in Pakistani rupees. Expenses are kept in memory only for now,
so they disappear when the app is closed.
