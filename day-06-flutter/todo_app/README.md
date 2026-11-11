# To-Do App

A simple to-do list. Add a task with a priority and an optional due date,
tick it off when it is done, and swipe it away to delete it. Tasks are saved
on the device, so they are still there when the app is opened again.

## Features

- Add a task with a title, priority (low, medium, high) and optional due date
- Tick tasks off, with a progress count at the top
- Filter by all, active or done
- Overdue tasks are shown in red
- Swipe to delete, with undo
- Clear all finished tasks at once
- Tasks saved on the device with shared_preferences

## How to run it

```
flutter pub get
flutter run
```

## What I practised

- Saving and loading a list as JSON with shared_preferences
- Keeping the task model and the storage code in their own files
- Filtering and sorting a list
- A bottom sheet form with validation and a date picker
- Unit tests for the model and storage, widget tests for adding and ticking off a task
