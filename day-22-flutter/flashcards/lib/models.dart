import 'dart:convert';

class Flashcard {
  Flashcard({required this.front, required this.back, this.known = false});

  final String front;
  final String back;
  bool known;

  Map<String, dynamic> toJson() => {
    'front': front,
    'back': back,
    'known': known,
  };

  factory Flashcard.fromJson(Map<String, dynamic> json) => Flashcard(
    front: json['front'] as String,
    back: json['back'] as String,
    known: json['known'] as bool? ?? false,
  );
}

class Deck {
  Deck({required this.title, required this.cards});

  final String title;
  final List<Flashcard> cards;

  int get knownCount => cards.where((c) => c.known).length;

  double get progress => cards.isEmpty ? 0 : knownCount / cards.length;

  void reset() {
    for (final card in cards) {
      card.known = false;
    }
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'cards': cards.map((c) => c.toJson()).toList(),
  };

  factory Deck.fromJson(Map<String, dynamic> json) => Deck(
    title: json['title'] as String,
    cards: (json['cards'] as List)
        .map((c) => Flashcard.fromJson(c as Map<String, dynamic>))
        .toList(),
  );

  static String encodeList(List<Deck> decks) =>
      jsonEncode(decks.map((d) => d.toJson()).toList());

  static List<Deck> decodeList(String raw) {
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((d) => Deck.fromJson(d as Map<String, dynamic>))
        .toList();
  }
}
