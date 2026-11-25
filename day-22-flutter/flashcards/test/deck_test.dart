import 'package:flashcards/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('progress is zero for an empty deck', () {
    final deck = Deck(title: 'Empty', cards: []);
    expect(deck.progress, 0);
    expect(deck.knownCount, 0);
  });

  test('progress counts only known cards', () {
    final deck = Deck(
      title: 'Test',
      cards: [
        Flashcard(front: 'Q1', back: 'A1', known: true),
        Flashcard(front: 'Q2', back: 'A2'),
        Flashcard(front: 'Q3', back: 'A3', known: true),
        Flashcard(front: 'Q4', back: 'A4'),
      ],
    );
    expect(deck.knownCount, 2);
    expect(deck.progress, 0.5);
  });

  test('reset clears all known flags', () {
    final deck = Deck(
      title: 'Test',
      cards: [Flashcard(front: 'Q1', back: 'A1', known: true)],
    );
    deck.reset();
    expect(deck.knownCount, 0);
  });

  test('deck survives a JSON round trip', () {
    final deck = Deck(
      title: 'Test',
      cards: [
        Flashcard(front: 'Q1', back: 'A1', known: true),
        Flashcard(front: 'Q2', back: 'A2'),
      ],
    );
    final restored = Deck.fromJson(deck.toJson());
    expect(restored.title, 'Test');
    expect(restored.cards.length, 2);
    expect(restored.cards[0].known, isTrue);
    expect(restored.cards[1].back, 'A2');
  });

  test('a list of decks survives a JSON round trip', () {
    final decks = [
      Deck(
        title: 'One',
        cards: [Flashcard(front: 'Q', back: 'A')],
      ),
      Deck(title: 'Two', cards: []),
    ];
    final restored = Deck.decodeList(Deck.encodeList(decks));
    expect(restored.length, 2);
    expect(restored[0].title, 'One');
    expect(restored[1].cards, isEmpty);
  });
}
