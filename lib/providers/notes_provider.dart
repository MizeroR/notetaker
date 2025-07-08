import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/notes_service.dart';
import '../services/auth_service.dart';

class NotesProvider extends ChangeNotifier {
  final NotesService _notesService = NotesService();
  final AuthService _authService = AuthService();
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes() async {
    final user = _authService.currentUser;
    if (user == null) {
      _notes = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _notes = await _notesService.fetchNotes(user.uid);
    } catch (e) {
      _notes = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(String text) async {
    final user = _authService.currentUser;
    if (user == null) throw 'User not authenticated';
    try {
      await _notesService.addNote(text, user.uid);
      await fetchNotes();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await _notesService.updateNote(id, text);
      await fetchNotes();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _notesService.deleteNote(id);
      await fetchNotes();
    } catch (e) {
      rethrow;
    }
  }
}
