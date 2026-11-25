import 'package:flutter/material.dart';

import 'add_card_page.dart';
import 'models.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key, required this.deck});

  final Deck deck;

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int _index = 0;
  bool _showingAnswer = false;
  bool _finished = false;

  List<Flashcard> get _cards => widget.deck.cards;

  void _flip() {
    setState(() => _showingAnswer = !_showingAnswer);
  }

  void _mark(bool known) {
    _cards[_index].known = known;
    if (_index + 1 < _cards.length) {
      setState(() {
        _index++;
        _showingAnswer = false;
      });
    } else {
      setState(() => _finished = true);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _showingAnswer = false;
      _finished = false;
    });
  }

  Future<void> _addCard() async {
    final card = await Navigator.of(
      context,
    ).push<Flashcard>(MaterialPageRoute(builder: (_) => const AddCardPage()));
    if (card == null) return;
    setState(() => _cards.add(card));
  }

  @override
  Widget build(BuildContext context) {
    final deck = widget.deck;

    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(deck.title)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This deck has no cards yet.'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _addCard,
                icon: const Icon(Icons.add),
                label: const Text('Add your first card'),
              ),
            ],
          ),
        ),
      );
    }

    if (_finished) {
      final unknown = _cards.where((c) => !c.known).length;
      return Scaffold(
        appBar: AppBar(title: Text(deck.title)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${deck.knownCount} of ${_cards.length} known',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                unknown == 0
                    ? 'All done — nice work.'
                    : '$unknown card${unknown == 1 ? '' : 's'} still to learn.',
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                    onPressed: _restart,
                    child: const Text('Study again'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Back to decks'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final card = _cards[_index];

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add a card',
            onPressed: _addCard,
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Start over',
            onPressed: () {
              deck.reset();
              _restart();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Card ${_index + 1} of ${_cards.length}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: (_index + 1) / _cards.length),
            const SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onTap: _flip,
                child: Card(
                  elevation: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showingAnswer ? 'Answer' : 'Question',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _showingAnswer ? card.back : card.front,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _showingAnswer
                                ? 'Tap to see the question again'
                                : 'Tap the card to see the answer',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showingAnswer ? () => _mark(false) : null,
                    icon: const Icon(Icons.close),
                    label: const Text("Didn't know"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _showingAnswer ? () => _mark(true) : null,
                    icon: const Icon(Icons.check),
                    label: const Text('Knew it'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Flip the card first, then mark whether you knew it.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
