import 'package:flutter/material.dart';

import 'deck_store.dart';
import 'models.dart';
import 'study_page.dart';

void main() {
  runApp(const FlashcardsApp());
}

class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const DeckListPage(),
    );
  }
}

class DeckListPage extends StatefulWidget {
  const DeckListPage({super.key});

  @override
  State<DeckListPage> createState() => _DeckListPageState();
}

class _DeckListPageState extends State<DeckListPage> {
  final _store = DeckStore();
  List<Deck> _decks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    final decks = await _store.load();
    if (!mounted) return;
    setState(() {
      _decks = decks;
      _loading = false;
    });
  }

  Future<void> _saveDecks() async {
    await _store.save(_decks);
  }

  Future<void> _openDeck(Deck deck) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => StudyPage(deck: deck)));
    // Progress may have changed on the study screen.
    setState(() {});
    await _saveDecks();
  }

  Future<void> _addDeck() async {
    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New deck'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Deck name',
            hintText: 'e.g. Biology terms',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(nameController.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    setState(() => _decks.add(Deck(title: name, cards: [])));
    await _saveDecks();
  }

  Future<void> _deleteDeck(Deck deck) async {
    final index = _decks.indexOf(deck);
    setState(() => _decks.remove(deck));
    await _saveDecks();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deck.title} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() => _decks.insert(index, deck));
            await _saveDecks();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My flashcards')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _decks.isEmpty
          ? const Center(
              child: Text('No decks yet. Tap + to make your first one.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _decks.length,
              itemBuilder: (context, index) {
                final deck = _decks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(deck.title.isEmpty ? '?' : deck.title[0]),
                    ),
                    title: Text(deck.title),
                    subtitle: Text(
                      '${deck.cards.length} cards  •  '
                      '${deck.knownCount} known',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 72,
                          child: LinearProgressIndicator(value: deck.progress),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteDeck(deck),
                        ),
                      ],
                    ),
                    onTap: () => _openDeck(deck),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDeck,
        tooltip: 'New deck',
        child: const Icon(Icons.add),
      ),
    );
  }
}
