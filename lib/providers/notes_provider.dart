import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/notes_service.dart';

class NotesProvider extends ChangeNotifier {
  final NotesService _notesService = NotesService();
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _notes = await _notesService.fetchNotes(userId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(String text, String userId) async {
    try {
      await _notesService.addNote(text, userId);
      await fetchNotes(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNote(String id, String text, String userId) async {
    try {
      await _notesService.updateNote(id, text);
      await fetchNotes(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(String id, String userId) async {
    try {
      await _notesService.deleteNote(id);
      await fetchNotes(userId);
    } catch (e) {
      rethrow;
    }
  }
}
