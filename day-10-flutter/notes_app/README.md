# Notes App

Day 10 of my daily project series — a simple notes app built with Flutter and Dart.

Notes can be created, edited, pinned and deleted. Everything is saved on
the device with shared_preferences, so notes are still there when the app
is opened again.

## Features

- Notes list with title, date and a preview of the first line
- Add a note and edit it later from the same screen
- Pin important notes so they stay at the top
- Search across titles and note text
- Swipe a note to delete it, with an Undo option
- Notes are saved on the device and loaded again on startup

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

- Keeping the note model and the search/sort logic in plain Dart
  (`lib/note.dart`) so it can be tested without widgets
- Saving and loading a list of objects as JSON with shared_preferences
  (`lib/note_store.dart`)
- A list screen and an editor screen with navigation between them
- `Dismissible` for swipe-to-delete with a SnackBar undo action
- Unit tests for the model and widget tests for adding and searching notes
- Material 3 theming with a seed colour
