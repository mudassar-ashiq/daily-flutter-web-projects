# Workout Tracker

Day 24 of my daily project series — a simple workout tracker built with
Flutter and Dart.

It comes with three workouts to start with (chest day, leg day, and back
and arms). You can log your own workouts, add exercises with sets, reps
and weight to each one, and see how much you lifted this week. Everything
is saved on the phone.

## Features

- Workout list with date, exercise count, sets and total volume
- This-week summary: workouts done and total weight lifted
- Tap a workout to see its exercises and add more
- Add your own workouts and exercises, delete with Undo
- Workouts and exercises saved with shared_preferences

## How to run

```bash
flutter pub get
flutter run
```

## What I practised

Keeping nested data (workouts with a list of exercises) in model classes
with JSON save and load, working out totals like volume from the models,
and writing unit and widget tests for the workout logic and the list flow.
