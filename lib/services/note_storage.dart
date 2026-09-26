import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workplace_notes/models/note_model.dart';

class NoteStorage {
  static const String _keyNotes = 'user_notes';

  // 💾 Simpan seluruh List Note ke SharedPreferences
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      notes.map((note) => note.toMap()).toList(),
    );
    await prefs.setString(_keyNotes, encodedData);
  }

  // 📂 Muat List Note dari SharedPreferences
  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString(_keyNotes);

    if (notesString == null || notesString.isEmpty) {
      return [];
    }

    final List<dynamic> decodedData = jsonDecode(notesString);
    return decodedData.map((item) => Note.fromMap(item)).toList();
  }
}
