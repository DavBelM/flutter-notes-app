import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}
