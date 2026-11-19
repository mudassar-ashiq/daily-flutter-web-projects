# Habit Tracker

Day 16 of my daily project series — a habit tracker built with Flutter and Dart.

Add the habits you want to keep up with, tap the circle each day you do
one, and watch the streak grow. Each habit has a weekly target (how many
days a week you want to do it) and a row of dots for the current week, so
you can see at a glance where you stand. Habits are saved on the phone,
so they are still there when you open the app again.

## Features

- Add habits with a name, colour and target days per week
- Tap to mark today done (or undo it)
- Streak count for each habit, counted back from today
- Monday-to-Sunday dots showing which days were done this week
- A "today" progress bar at the top
- Swipe a habit left to delete it, with undo
- Habits saved with shared_preferences

## How to run

```
flutter pub get
flutter run
```

## Tests

```
flutter test
```

## What I practised

- Keeping the date logic (streaks, week view) in a plain model class
  (`lib/models/habit.dart`) so it can be tested without the UI
- Saving a list of objects as JSON with shared_preferences
  (`lib/services/habit_store.dart`)
- A dialog with its own local state for the add-habit form
- Unit tests for streaks and week counting, widget tests for the home screen
