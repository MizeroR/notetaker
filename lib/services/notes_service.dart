import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notes';

  Future<List<Note>> fetchNotes(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Note.fromMap(doc.data(), doc.id))
          .toList();
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
