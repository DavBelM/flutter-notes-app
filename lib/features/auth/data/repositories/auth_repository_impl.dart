import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    print('🔥 Firebase Auth instance: ${_firebaseAuth.hashCode}');
    print(
      '🔥 Current user before login: ${_firebaseAuth.currentUser?.email ?? 'none'}',
    );

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('🔥 FirebaseAuthException Code: ${e.code}');
      print('🔥 FirebaseAuthException Message: ${e.message}');
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      print('🔥 General Exception: $e');
      throw 'An unexpected error occurred: $e';
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('🔥 FirebaseAuthException Code: ${e.code}');
      print('🔥 FirebaseAuthException Message: ${e.message}');
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      print('🔥 General Exception: $e');
      throw 'An unexpected error occurred: $e';
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String _mapFirebaseAuthException(FirebaseAuthException e) {
    print('🔥 Mapping Firebase Error: ${e.code}');
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'invalid-credential':
        return 'The email or password is incorrect.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        print('🔥 Unmapped Firebase Error: ${e.code} - ${e.message}');
        return 'Authentication failed: ${e.message ?? e.code}';
    }
  }
}
