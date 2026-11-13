import 'dart:convert';

class Note {
  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.pinned = false,
  });

  final String id;
  String title;
  String body;
  final DateTime createdAt;
  DateTime updatedAt;
  bool pinned;

  // First line of the body, used as a preview in the list.
  String get preview {
    final lines = body.split('\n').where((line) => line.trim().isNotEmpty);
    return lines.isEmpty ? 'No additional text' : lines.first.trim();
  }

  String get displayTitle =>
      title.trim().isEmpty ? 'Untitled note' : title.trim();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'pinned': pinned,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    body: json['body'] as String? ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    pinned: json['pinned'] as bool? ?? false,
  );

  static String encodeList(List<Note> notes) =>
      jsonEncode(notes.map((note) => note.toJson()).toList());

  static List<Note> decodeList(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Note.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

// Pinned notes first, then most recently updated.
List<Note> sortNotes(List<Note> notes) {
  final sorted = List<Note>.of(notes);
  sorted.sort((a, b) {
    if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
    return b.updatedAt.compareTo(a.updatedAt);
  });
  return sorted;
}

// Case-insensitive search across title and body.
List<Note> searchNotes(List<Note> notes, String query) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) return List<Note>.of(notes);
  return notes
      .where(
        (note) =>
            note.title.toLowerCase().contains(needle) ||
            note.body.toLowerCase().contains(needle),
      )
      .toList();
}
