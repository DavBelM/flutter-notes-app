import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class NotesStarted extends NotesEvent {
  final String userId;

  const NotesStarted(this.userId);

  @override
  List<Object> get props => [userId];
}

class NotesRefreshed extends NotesEvent {
  final String userId;

  const NotesRefreshed(this.userId);

  @override
  List<Object> get props => [userId];
}

class NoteAdded extends NotesEvent {
  final String text;
  final String userId;

  const NoteAdded({required this.text, required this.userId});

  @override
  List<Object> get props => [text, userId];
}

class NoteUpdated extends NotesEvent {
  final String id;
  final String text;

  const NoteUpdated({required this.id, required this.text});

  @override
  List<Object> get props => [id, text];
}

class NoteDeleted extends NotesEvent {
  final String id;

  const NoteDeleted(this.id);

  @override
  List<Object> get props => [id];
}
