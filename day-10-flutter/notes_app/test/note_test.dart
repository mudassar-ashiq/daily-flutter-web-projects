import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/note.dart';

Note makeNote({
  String id = '1',
  String title = 'Shopping',
  String body = 'Buy milk and bread',
  bool pinned = false,
  DateTime? updatedAt,
}) {
  final now = updatedAt ?? DateTime(2026, 11, 13, 9, 0);
  return Note(
    id: id,
    title: title,
    body: body,
    createdAt: now,
    updatedAt: now,
    pinned: pinned,
  );
}

void main() {
  group('Note JSON', () {
    test('round-trips through toJson and fromJson', () {
      final note = makeNote(pinned: true);
      final restored = Note.fromJson(note.toJson());
      expect(restored.id, '1');
      expect(restored.title, 'Shopping');
      expect(restored.body, 'Buy milk and bread');
      expect(restored.pinned, isTrue);
      expect(restored.updatedAt, note.updatedAt);
    });

    test('a list encodes and decodes', () {
      final notes = [makeNote(id: '1'), makeNote(id: '2', title: 'Ideas')];
      final restored = Note.decodeList(Note.encodeList(notes));
      expect(restored.map((n) => n.id), ['1', '2']);
      expect(restored[1].title, 'Ideas');
    });
  });

  group('display helpers', () {
    test('empty title shows as Untitled note', () {
      expect(makeNote(title: '   ').displayTitle, 'Untitled note');
    });

    test('preview is the first non-empty line of the body', () {
      final note = makeNote(body: '\n\nFirst line\nSecond line');
      expect(note.preview, 'First line');
    });

    test('preview falls back when the body is empty', () {
      expect(makeNote(body: '').preview, 'No additional text');
    });
  });

  group('sortNotes', () {
    test('pinned notes come first, then newest first', () {
      final old = makeNote(id: 'old', updatedAt: DateTime(2026, 11, 10));
      final newer = makeNote(id: 'new', updatedAt: DateTime(2026, 11, 12));
      final pinnedOld = makeNote(
        id: 'pinned',
        pinned: true,
        updatedAt: DateTime(2026, 11, 9),
      );
      final sorted = sortNotes([old, newer, pinnedOld]);
      expect(sorted.map((n) => n.id), ['pinned', 'new', 'old']);
    });
  });

  group('searchNotes', () {
    test('matches title or body, case-insensitively', () {
      final notes = [
        makeNote(id: '1', title: 'Flutter notes', body: 'widgets'),
        makeNote(id: '2', title: 'Groceries', body: 'buy FLUTTER book'),
        makeNote(id: '3', title: 'Random', body: 'nothing here'),
      ];
      final found = searchNotes(notes, 'flutter');
      expect(found.map((n) => n.id), ['1', '2']);
    });

    test('empty query returns everything', () {
      final notes = [makeNote(id: '1'), makeNote(id: '2')];
      expect(searchNotes(notes, '  ').length, 2);
    });
  });
}
