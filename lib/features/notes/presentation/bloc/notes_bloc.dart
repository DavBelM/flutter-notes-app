import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notes_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _notesRepository;

  NotesBloc(this._notesRepository) : super(NotesInitial()) {
    on<NotesStarted>(_onNotesStarted);
    on<NotesRefreshed>(_onNotesRefreshed);
    on<NoteAdded>(_onNoteAdded);
    on<NoteUpdated>(_onNoteUpdated);
    on<NoteDeleted>(_onNoteDeleted);
  }

  void _onNotesStarted(NotesStarted event, Emitter<NotesState> emit) async {
    print('📝 Notes Started for user: ${event.userId}');
    emit(NotesLoading());
    try {
      print('📝 Setting up notes stream...');

      // Use emit.forEach instead of manual subscription
      await emit.forEach(
        _notesRepository.getNotesStream(event.userId),
        onData: (notes) {
          print('📝 Notes received: ${notes.length} notes');
          return NotesLoaded(notes);
        },
        onError: (error, stackTrace) {
          print('📝 Notes stream error: $error');
          return NotesError(error.toString());
        },
      );
    } catch (e) {
      print('📝 Notes started error: $e');
      emit(NotesError(e.toString()));
    }
  }

  void _onNotesRefreshed(NotesRefreshed event, Emitter<NotesState> emit) async {
    try {
      final notes = await _notesRepository.fetchNotes(event.userId);
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  void _onNoteAdded(NoteAdded event, Emitter<NotesState> emit) async {
    try {
      print('📝 Adding note for user: ${event.userId}');
      await _notesRepository.addNote(event.text, event.userId);
      print('📝 Note added successfully');
      // Don't emit NotesActionSuccess - let the stream handle the update
    } catch (e) {
      print('📝 Error adding note: $e');
      emit(NotesError(e.toString()));
    }
  }

  void _onNoteUpdated(NoteUpdated event, Emitter<NotesState> emit) async {
    try {
      print('📝 Updating note: ${event.id}');
      await _notesRepository.updateNote(event.id, event.text);
      print('📝 Note updated successfully');
      // Don't emit NotesActionSuccess - let the stream handle the update
    } catch (e) {
      print('📝 Error updating note: $e');
      emit(NotesError(e.toString()));
    }
  }

  void _onNoteDeleted(NoteDeleted event, Emitter<NotesState> emit) async {
    try {
      print('📝 Deleting note: ${event.id}');
      await _notesRepository.deleteNote(event.id);
      print('📝 Note deleted successfully');
      // Don't emit NotesActionSuccess - let the stream handle the update
    } catch (e) {
      print('📝 Error deleting note: $e');
      emit(NotesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
