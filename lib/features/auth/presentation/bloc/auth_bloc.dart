import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    _authSubscription = _authRepository.authStateChanges.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  void _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🔑 Sign In Requested for: ${event.email}');
    emit(AuthLoading());
    try {
      await _authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      print('✅ Sign In Success');
    } catch (e) {
      print('❌ Sign In Error: $e');
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('📝 Sign Up Requested for: ${event.email}');
    emit(AuthLoading());
    try {
      await _authRepository.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );
      print('✅ Sign Up Success');
    } catch (e) {
      print('❌ Sign Up Error: $e');
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    print('👤 Auth User Changed: ${event.user?.email ?? 'null'}');
    if (event.user != null) {
      print('✅ User Authenticated: ${event.user!.email}');
      emit(AuthAuthenticated(event.user!));
    } else {
      print('❌ User Unauthenticated');
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
