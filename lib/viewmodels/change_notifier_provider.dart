import 'package:flutter/material.dart';
import 'package:notes/data/repositories/local/notes_repository.dart';
import 'package:notes/models/notes_model.dart';
import 'package:uuid/uuid.dart';

class NotesProvider extends ChangeNotifier {
  final NotesRepository notesRepository = NotesRepository();
  List<NotesModel> _notes = [];
  List<NotesModel> get notes => _notes;


  NotesProvider() {
    getNotes();
  }

  Future<void> getNotes() async {
    _notes = await notesRepository.getNotes();
    notifyListeners();
  }


  static String generateId() {
    return Uuid().v4();
  }

  Future<void> convertToNotesModel(String title, String description) async {
    final note = NotesModel(
      id: generateId(),
      title: title,
      description: description,
      createOrUpdatedAt: DateTime.now(),
    );
    _notes.add(note);
    notifyListeners();
    await notesRepository.addNote(note);
  }

  Future<void> deleteNote(String id) async {
    try {
      _notes.removeWhere((note) => note.id == id);
      notifyListeners();
      await notesRepository.deleteNotes(id);
    } catch (e) {
      print('there is an exception in deleteNote: $e');
    }
  }
}
