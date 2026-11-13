import 'package:flutter/material.dart';

import 'note.dart';
import 'note_store.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];
  NoteStore? _store;
  bool _loading = true;
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final store = await NoteStore.load();
    setState(() {
      _store = store;
      _notes = store.loadNotes();
      _loading = false;
    });
  }

  Future<void> _save() async {
    await _store?.saveNotes(_notes);
  }

  List<Note> get _visibleNotes => sortNotes(searchNotes(_notes, _query));

  Future<void> _openEditor({Note? note}) async {
    final result = await Navigator.of(context).push<Note?>(
      MaterialPageRoute(builder: (_) => NoteEditorPage(note: note)),
    );
    if (result == null) return;
    setState(() {
      final index = _notes.indexWhere((n) => n.id == result.id);
      if (index >= 0) {
        _notes[index] = result;
      } else {
        _notes.insert(0, result);
      }
    });
    await _save();
  }

  void _togglePin(Note note) {
    setState(() => note.pinned = !note.pinned);
    _save();
  }

  void _deleteNote(Note note) {
    final index = _notes.indexOf(note);
    setState(() => _notes.remove(note));
    _save();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() => _notes.insert(index, note));
            _save();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = _visibleNotes;
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search notes',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                Expanded(
                  child: notes.isEmpty
                      ? Center(
                          child: Text(
                            _query.isEmpty
                                ? 'No notes yet. Tap + to write one.'
                                : 'No notes match "$_query".',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return Dismissible(
                              key: ValueKey(note.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                                child: const Icon(Icons.delete),
                              ),
                              onDismissed: (_) => _deleteNote(note),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    note.displayTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${formatDate(note.updatedAt)}\n${note.preview}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  isThreeLine: true,
                                  trailing: IconButton(
                                    icon: Icon(
                                      note.pinned
                                          ? Icons.push_pin
                                          : Icons.push_pin_outlined,
                                    ),
                                    onPressed: () => _togglePin(note),
                                    tooltip: note.pinned
                                        ? 'Unpin note'
                                        : 'Pin note',
                                  ),
                                  onTap: () => _openEditor(note: note),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        tooltip: 'New note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key, this.note});

  final Note? note;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _saveAndClose() {
    final now = DateTime.now();
    final existing = widget.note;
    final note =
        existing ??
        Note(
          id: now.microsecondsSinceEpoch.toString(),
          title: '',
          body: '',
          createdAt: now,
          updatedAt: now,
        );
    note.title = _titleController.text;
    note.body = _bodyController.text;
    note.updatedAt = now;
    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.note == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'New note' : 'Edit note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save note',
            onPressed: _saveAndClose,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  hintText: 'Write your note here...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
