# Flashcards

Day 22 of my daily project series — a simple flashcards app for studying,
built with Flutter and Dart.

It comes with three decks to start with (Flutter basics, English words and
Pakistan GK). You can study a deck by tapping a card to flip it, then mark
whether you knew the answer. You can also add your own decks and cards, and
everything is saved on the phone.

## Features

- Deck list with card count, known count and a progress bar
- Tap a card to flip it between question and answer
- Mark each card as "Knew it" or "Didn't know", with a summary at the end
- Add your own decks and cards
- Decks and progress saved with shared_preferences
- Swipe-free delete with Undo on the deck list

## How to run

```bash
flutter pub get
flutter run
```

## What I practised

Keeping the deck data in a small model class with JSON save and load,
splitting the screens into separate files, and writing unit and widget
tests for the deck logic and the study flow.
