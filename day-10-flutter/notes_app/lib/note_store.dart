import 'package:shared_preferences/shared_preferences.dart';

import 'note.dart';

class NoteStore {
  NoteStore(this._prefs);

  static const _key = 'notes';

  final SharedPreferences _prefs;

  static Future<NoteStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return NoteStore(prefs);
  }

  List<Note> loadNotes() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return Note.decodeList(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> saveNotes(List<Note> notes) async {
    await _prefs.setString(_key, Note.encodeList(notes));
  }
}
