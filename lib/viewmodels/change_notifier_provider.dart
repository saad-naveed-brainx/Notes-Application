import 'package:flutter/material.dart';
import 'package:notes/data/repositories/local/notes_repository.dart';
import 'package:notes/models/notes_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class NotesProvider extends ChangeNotifier {
  final NotesRepository notesRepository = NotesRepository();
  List<NotesModel> _notes = [];
  List<NotesModel> get notes => _notes;

  NotesProvider() {
    getNotes();
  }

  String generateRandomColorHex() {
    final random = Random();

    // Base colors in RGB for your hues:
    final baseColors = {
      'yellow': [255, 215, 0], // #FFD700
      'blue': [173, 216, 230], // light blue-ish (instead of pure #0000FF)
      'green': [144, 238, 144], // light green-ish (instead of #008000)
      'grey': [128, 128, 128], // grey
    };

    // Pick a random base color
    final keys = baseColors.keys.toList();
    final base = baseColors[keys[random.nextInt(keys.length)]]!;

    // Add some random variation to each RGB channel (+/- 30)
    int clamp(int val) => val.clamp(0, 255);

    final r = clamp(base[0] + random.nextInt(61) - 30);
    final g = clamp(base[1] + random.nextInt(61) - 30);
    final b = clamp(base[2] + random.nextInt(61) - 30);

    // Convert to hex string with padding and return
    String toHex(int val) => val.toRadixString(16).padLeft(2, '0');

    return '#${toHex(r)}${toHex(g)}${toHex(b)}';
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
      backgroundColorHex: generateRandomColorHex(),
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

  Future<void> updateNote(NotesModel note) async {
    try {
      final index = _notes.indexWhere((element) => element.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        notifyListeners();
        await notesRepository.addNote(note);
      }
    } catch (e) {
      print('there is an exception in updateNote: $e');
    }
  }
}
