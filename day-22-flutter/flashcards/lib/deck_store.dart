import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'sample_decks.dart';

const _decksKey = 'flashcards_decks';

// Keeps the decks on the phone, so added cards are still there
// next time the app opens.
class DeckStore {
  Future<List<Deck>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_decksKey);
    if (raw == null || raw.isEmpty) {
      return sampleDecks();
    }
    try {
      return Deck.decodeList(raw);
    } catch (_) {
      return sampleDecks();
    }
  }

  Future<void> save(List<Deck> decks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_decksKey, Deck.encodeList(decks));
  }
}
