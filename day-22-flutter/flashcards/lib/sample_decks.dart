import 'models.dart';

// A few decks to start with, so the app is useful straight away.
List<Deck> sampleDecks() {
  return [
    Deck(
      title: 'Flutter basics',
      cards: [
        Flashcard(
          front: 'What is a Widget in Flutter?',
          back: 'Everything in Flutter is a widget — buttons, text, layouts and even the app itself are all widgets.',
        ),
        Flashcard(
          front: 'StatelessWidget or StatefulWidget?',
          back: 'Use StatelessWidget when the screen never changes. Use StatefulWidget when something on screen can change, like a counter.',
        ),
        Flashcard(
          front: 'What does setState do?',
          back: 'It tells Flutter that something changed, so the widget rebuilds and shows the new value.',
        ),
        Flashcard(
          front: 'What is pubspec.yaml for?',
          back: 'It lists the app name, version and the packages the app depends on.',
        ),
        Flashcard(
          front: 'What is hot reload?',
          back: 'It updates the running app with your code changes in seconds, without losing the app state.',
        ),
      ],
    ),
    Deck(
      title: 'English words',
      cards: [
        Flashcard(
          front: 'Diligent',
          back: 'Working hard and carefully. Example: "She is a diligent student."',
        ),
        Flashcard(
          front: 'Reluctant',
          back: 'Not willing to do something. Example: "He was reluctant to leave."',
        ),
        Flashcard(
          front: 'Concise',
          back: 'Short and clear, without extra words. Example: "Give a concise answer."',
        ),
        Flashcard(
          front: 'Obsolete',
          back: 'No longer used, out of date. Example: "That old phone is obsolete now."',
        ),
      ],
    ),
    Deck(
      title: 'Pakistan GK',
      cards: [
        Flashcard(front: 'Capital of Pakistan', back: 'Islamabad'),
        Flashcard(front: 'National language of Pakistan', back: 'Urdu'),
        Flashcard(front: 'Largest city of Pakistan', back: 'Karachi'),
        Flashcard(front: 'National animal of Pakistan', back: 'Markhor'),
        Flashcard(
          front: 'When did Pakistan come into being?',
          back: '14 August 1947',
        ),
      ],
    ),
  ];
}
