import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/note.dart';

class NotesService {
  FirebaseFirestore get _firestore {
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase not initialized');
    }
    return FirebaseFirestore.instance;
  }
  final String _collection = 'notes';

  Future<List<Note>> fetchNotes(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      final notes = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data.isEmpty) return null;
            return Note.fromMap(data, doc.id);
          })
          .where((note) => note != null)
          .cast<Note>()
          .toList();
      
      // Sort by updatedAt in descending order
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    } catch (e) {
      throw 'Failed to fetch notes: ${e.toString()}';
    }
  }

  Future<void> addNote(String text, String userId) async {
    try {
      final now = DateTime.now();
      final note = Note(
        id: '',
        text: text,
        createdAt: now,
        updatedAt: now,
        userId: userId,
      );

      await _firestore.collection(_collection).add(note.toMap());
    } catch (e) {
      throw 'Failed to add note: ${e.toString()}';
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'text': text,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw 'Failed to update note: ${e.toString()}';
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw 'Failed to delete note: ${e.toString()}';
    }
  }
}
