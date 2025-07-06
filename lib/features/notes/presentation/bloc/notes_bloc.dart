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
    emit(NotesLoading());
    try {
      // Use emit.forEach instead of manual subscription
      await emit.forEach(
        _notesRepository.getNotesStream(event.userId),
        onData: (notes) {
          return NotesLoaded(notes);
        },
        onError: (error, stackTrace) {
          return NotesError(error.toString());
        },
      );
    } catch (e) {
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
      await _notesRepository.addNote(event.text, event.userId);
      // Don't emit NotesActionSuccess - let the stream handle the update
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  void _onNoteUpdated(NoteUpdated event, Emitter<NotesState> emit) async {
    try {
      await _notesRepository.updateNote(event.id, event.text);
      // Don't emit NotesActionSuccess - let the stream handle the update
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  void _onNoteDeleted(NoteDeleted event, Emitter<NotesState> emit) async {
    try {
      await _notesRepository.deleteNote(event.id);
      // Don't emit NotesActionSuccess - let the stream handle the update
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
