import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class TodoService {
  static final TodoService _instance = TodoService._internal();
  factory TodoService() => _instance;
  TodoService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'todos';

  // Get all todos as a stream
  Stream<List<Todo>> getTodos() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList();
        });
  }

  // Add a new todo
  Future<void> addTodo(String title, String description) async {
    try {
      await _firestore.collection(_collection).add({
        'title': title,
        'description': description,
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': null,
      });
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  // Update a todo
  Future<void> updateTodo(Todo todo) async {
    try {
      await _firestore.collection(_collection).doc(todo.id).update({
        'title': todo.title,
        'description': todo.description,
        'isCompleted': todo.isCompleted,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  // Toggle todo completion status
  Future<void> toggleTodoCompletion(Todo todo) async {
    try {
      await _firestore.collection(_collection).doc(todo.id).update({
        'isCompleted': !todo.isCompleted,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to toggle todo: $e');
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String todoId) async {
    try {
      await _firestore.collection(_collection).doc(todoId).delete();
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }

  // Get completed todos count
  Future<int> getCompletedTodosCount() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('isCompleted', isEqualTo: true)
              .get();
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get completed todos count: $e');
    }
  }

  // Get pending todos count
  Future<int> getPendingTodosCount() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('isCompleted', isEqualTo: false)
              .get();
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get pending todos count: $e');
    }
  }
}
