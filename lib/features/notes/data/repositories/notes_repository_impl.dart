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
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
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

      await _firestore.collection(_collection).add(note.toFirestore());
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
    print('🔥 Setting up Firestore stream for user: $userId');
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          print(
            '🔥 Firestore snapshot received: ${snapshot.docs.length} documents',
          );
          return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
        });
  }
}
