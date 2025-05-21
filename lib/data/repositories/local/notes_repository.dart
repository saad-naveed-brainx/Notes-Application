import 'package:notes/models/notes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesRepository {
  final List<NotesModel> notes = [];

  Future<void> addNote(NotesModel note) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingNotes = prefs.getString('notes');
    List<NotesModel> notes = [];
    if (existingNotes != null && existingNotes.isNotEmpty) {
      final List<dynamic> decodedNotes = jsonDecode(existingNotes);
      notes = decodedNotes.map((e) => NotesModel.fromJson(e)).toList();
    }

    final Map<String, NotesModel> notesMap = {for (var e in notes) e.id: e};
    notesMap[note.id] = note;
    final updatedList = notesMap.values.toList();
    final String encodedNotes = jsonEncode(
      updatedList.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('notes', encodedNotes);
  }

  Future<List<NotesModel>> getNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedNotes = prefs.getString('notes');
      if (encodedNotes == null || encodedNotes.isEmpty) return [];
      final List<dynamic> decodedNotes = jsonDecode(encodedNotes);
      return decodedNotes.map((e) => NotesModel.fromJson(e)).toList();
    } catch (e) {
      print('there is an exception in getNotes: $e');
      return [];
    }
  }

  Future<void> deleteNotes(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedNotes = prefs.getString('notes');
      if (encodedNotes == null || encodedNotes.isEmpty) return;
      final List<dynamic> decodedNotes = jsonDecode(encodedNotes);

      final List<NotesModel> notes =
          decodedNotes.map((e) => NotesModel.fromJson(e)).toList();

      final List<NotesModel> filteredNotes =
          notes.where((e) => e.id != id).toList();

      final String encodedNotesAgain = jsonEncode(
        filteredNotes.map((e) => e.toJson()).toList(),
      );
      await prefs.setString('notes', encodedNotesAgain);
    } catch (e) {
      print('there is an exception in deleteNotes: $e');
    }
  }
}
