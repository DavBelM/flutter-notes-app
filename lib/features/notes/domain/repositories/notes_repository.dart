import '../entities/note.dart';

abstract class NotesRepository {
  Future<List<Note>> fetchNotes(String userId);
  Future<void> addNote(String text, String userId);
  Future<void> updateNote(String id, String text);
  Future<void> deleteNote(String id);
  Stream<List<Note>> getNotesStream(String userId);
}
