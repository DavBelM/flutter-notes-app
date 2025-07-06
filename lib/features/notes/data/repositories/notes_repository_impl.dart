import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'notes';

  NotesRepositoryImpl(this._firestore);

  @override
  Future<List<Note>> fetchNotes(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_collection)
              .where('userId', isEqualTo: userId)
              .get();

      final notes =
          querySnapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();

      // Sort manually to avoid needing a composite index
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return notes;
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  @override
  Future<void> addNote(String text, String userId) async {
    try {
      final now = DateTime.now();
      final note = Note(
        id: '',
        text: text,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      );

      final docData = note.toFirestore();
      await _firestore.collection(_collection).add(docData);
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  @override
  Future<void> updateNote(String id, String text) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'text': text,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  @override
  Stream<List<Note>> getNotesStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          // Sort manually by createdAt to avoid index requirement
          var notes =
              snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
          notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return notes;
        });
  }
}
