# Flutter Notes App

A professional Flutter application for managing notes with Firebase integration, built using clean architecture principles and BLoC state management.

## Features

- **User Authentication**: Sign up, login, and logout functionality
- **CRUD Operations**: Create, Read, Update, and Delete notes
- **Real-time Sync**: Notes are synchronized with Firebase Firestore
- **Categorized Notes**: Organize notes by categories (Work, Personal, Ideas, etc.)
- **Modern UI**: Beautiful, responsive interface with gradient backgrounds
- **Clean Architecture**: Organized codebase following clean architecture principles
- **BLoC State Management**: Reactive state management with flutter_bloc

## Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Authentication)
- **State Management**: BLoC Pattern
- **Architecture**: Clean Architecture
- **Authentication**: Firebase Auth

## Project Structure

```
lib/
├── core/
│   ├── error/
│   └── theme/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── screens/
│   └── notes/
│       ├── data/
│       │   └── repositories/
│       └── presentation/
│           ├── bloc/
│           ├── screens/
│           └── widgets/
├── firebase_options.dart
└── main.dart
```

## Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/DavBelM/flutter-notes-app.git
   cd flutter-notes-app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**

   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication and Firestore Database
   - Add your Flutter app to the Firebase project
   - Download and replace `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Run: `flutterfire configure`

4. **Run the app**
   ```bash
   flutter run
   ```

## Firebase Setup

1. **Authentication**: Enable Email/Password authentication in Firebase Console
2. **Firestore**: Create a Firestore database with the following security rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /notes/{noteId} {
         allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
       }
     }
   }
   ```

## App Screenshots

### Authentication Flow

- Splash Screen with app branding
- Login/Signup forms with validation
- Password confirmation and error handling

### Notes Management

- Empty state with encouraging message
- Category-based note organization
- Create, edit, and delete operations
- Real-time synchronization with Firestore

## Dependencies

- `flutter_bloc`: ^8.1.6 - State management
- `firebase_core`: ^3.6.0 - Firebase initialization
- `firebase_auth`: ^5.3.1 - Authentication
- `cloud_firestore`: ^5.4.4 - Database
- `equatable`: ^2.0.5 - Value equality

## Architecture

This app follows **Clean Architecture** principles:

- **Data Layer**: Repositories and data sources
- **Domain Layer**: Business logic and entities
- **Presentation Layer**: UI components and state management

## State Management

The app uses **BLoC (Business Logic Component)** pattern for state management:

- `AuthBloc`: Handles authentication state
- `NotesBloc`: Manages notes CRUD operations

## Author

Built by [Mitali Bela](https://github.com/DavBelM) as a demonstration of Flutter development skills with Firebase integration.

## License

This project is open source and available under the MIT License.
