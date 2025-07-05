import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'core/theme/theme_data.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/presentation/bloc/notes_bloc.dart';
import 'features/notes/presentation/screens/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 Firebase initialized successfully');
    print('🔥 Project ID: ${DefaultFirebaseOptions.currentPlatform.projectId}');
    print(
      '🔥 Auth Domain: ${DefaultFirebaseOptions.currentPlatform.authDomain}',
    );
  } catch (e) {
    print('🔥 Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  AuthBloc(AuthRepositoryImpl(FirebaseAuth.instance))
                    ..add(AuthStarted()),
        ),
        BlocProvider(
          create:
              (context) =>
                  NotesBloc(NotesRepositoryImpl(FirebaseFirestore.instance)),
        ),
      ],
      child: MaterialApp(
        title: 'Your Notes',
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.interTextTheme(),
        ),
        home: const AppWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
        onFinish: () {
          setState(() {
            _showSplash = false;
          });
        },
      );
    }
    return const AuthWrapper();
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return NotesScreen(userId: state.user.uid);
        } else if (state is AuthUnauthenticated) {
          return const AuthScreen();
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const AuthScreen();
      },
    );
  }
}
