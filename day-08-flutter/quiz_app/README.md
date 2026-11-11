# Quiz App

Day 8 of my daily project series — a small quiz app built with Flutter and Dart.

The quiz has 10 questions: a mix of general knowledge and basic computer
science (data structures, Dart, networking). Each question has four options
and one correct answer.

## Features

- Start screen with the question count
- One question at a time, with a progress bar and "Question X of 10" label
- Tapping an answer shows right away whether it was correct or not
- Result screen with the final score and a short message
- Restart button to play again

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

- Keeping the quiz logic separate from the UI: the questions and the
  scoring/ progress logic live in `lib/quiz.dart` as plain Dart classes,
  so they can be tested without any widgets
- State management with `setState` in a `StatefulWidget`
- Model classes (`Question`) and a small engine class (`QuizEngine`)
- Unit tests for the logic and widget tests for the screens
- Material 3 theming with a seed colour
