# Flutter Notes App

A full-featured notes application built with Flutter, featuring Firebase authentication and cloud storage. This app demonstrates clean architecture principles with proper state management and CRUD operations.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                   │
├─────────────────────────────────────────────────────────────┤
│  Screens/          │  Widgets/         │  Providers/        │
│  ├── AuthWrapper   │  ├── NoteItem     │  ├── AuthProvider  │
│  ├── LoginScreen   │  └── AddEditDialog│  └── NotesProvider │
│  └── NotesScreen   │                   │                    │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                        BUSINESS LAYER                       │
├─────────────────────────────────────────────────────────────┤
│  Services/                                                  │
│  ├── AuthService (Firebase Auth)                           │
│  └── NotesService (Firestore CRUD)                         │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                         DATA LAYER                         │
├─────────────────────────────────────────────────────────────┤
│  Models/           │  Firebase/                             │
│  └── Note          │  ├── Authentication                    │
│                    │  └── Cloud Firestore                  │
└─────────────────────────────────────────────────────────────┘
```

## Features

- **Authentication**: Email/password signup and login
- **CRUD Operations**: Create, read, update, delete notes
- **Real-time Sync**: Notes sync across devices via Firestore
- **State Management**: Provider pattern for reactive UI
- **Clean Architecture**: Separation of concerns with services and providers
- **Responsive Design**: Works on various screen sizes
- **Error Handling**: Comprehensive error messages and loading states
- **Empty State**: User-friendly empty state with helpful messaging

## Screenshots

### Authentication Flow
- Login/Signup screen with validation
- Automatic routing based on auth state

### Notes Management
- Empty state: "Nothing here yet—tap ➕ to add a note."
- Notes list with edit/delete actions
- Add/edit note dialog with validation
- Success/error notifications via SnackBar

## Tech Stack

- **Framework**: Flutter 3.32.2
- **Language**: Dart 3.8.1
- **State Management**: Provider 6.1.1
- **Backend**: Firebase
  - Authentication: firebase\_auth 4.15.3
  - Database: cloud\_firestore 4.13.6
  - Core: firebase\_core 2.24.2
- **Development Environment**: 
  - Xcode 14.2
  - iOS Simulator
  - VS Code with Flutter extension

## Prerequisites

Before building this app, ensure you have:

- **Flutter SDK**: Version 3.0.0 or higher
- **Dart SDK**: Version 3.0.0 or higher
- **Xcode**: Version 14.0 or higher (for iOS)
- **CocoaPods**: Latest version
- **Firebase Project**: With Authentication and Firestore enabled
- **Git**: For version control

### System Requirements
- **macOS**: 12.0 or higher
- **iOS Simulator**: iOS 13.0 or higher
- **RAM**: Minimum 8GB recommended
- **Storage**: At least 10GB free space

## Build Steps

### 1. Environment Setup

```bash
# Verify Flutter installation
flutter doctor -v

# Ensure iOS development is ready
flutter doctor --android-licenses  # Skip if not using Android
```

### 2. Firebase Project Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `flutter-note-taker`
4. Disable Google Analytics (optional)
5. Click "Create project"

#### Enable Firebase Services
1. **Authentication**:
   - Navigate to Authentication → Sign-in method
   - Enable "Email/Password" provider
   - Save changes

2. **Firestore Database**:
   - Navigate to Firestore Database
   - Click "Create database"
   - Start in "Test mode"
   - Choose your preferred location
   - Click "Done"

#### Configure iOS App
1. In Firebase Console, click iOS icon to add iOS app
2. Enter iOS bundle ID: `com.example.flutterNotesApp`
3. Download `GoogleService-Info.plist`
4. Add to iOS project (see step 4 below)

### 3. Project Setup

```bash
# Clone the repository
git clone https://github.com/MizeroR/notetaker
cd notetaker

# Install dependencies
flutter pub get
```

### 4. iOS Configuration

```bash
# Add Firebase configuration to iOS
# 1. Open Xcode workspace
open ios/Runner.xcworkspace

# 2. In Xcode:
#    - Right-click "Runner" in project navigator
#    - Select "Add Files to Runner"
#    - Choose downloaded GoogleService-Info.plist
#    - Ensure "Copy items if needed" is checked
#    - Select "Runner" target
#    - Click "Add"
```

### 5. Firebase CLI Setup (Optional but Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (generates firebase_options.dart)
flutterfire configure
```

### 6. Build and Run

#### For iOS Simulator

```bash
# Clean previous builds
flutter clean
flutter pub get

# Open iOS Simulator
open -a Simulator

# Build and run
flutter run -d "iPhone 14"
```

#### For iOS Device (Optional)

```bash
# Connect iOS device via USB
# Enable Developer Mode on device

# Run on device
flutter run -d <device-name>
```

### 7. Troubleshooting Build Issues

#### CocoaPods Issues
```bash
# Update CocoaPods repository
pod repo update

# Clean and reinstall pods
cd ios
rm -rf Podfile.lock Pods/
pod install
cd ..
```

#### Firebase Configuration Issues
```bash
# Verify firebase_options.dart exists
ls lib/firebase_options.dart

# Regenerate if missing
flutterfire configure
```

#### Build Errors
```bash
# Complete clean build
flutter clean
cd ios && rm -rf build/ && cd ..
flutter pub get
flutter run -d "iPhone 14"
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/
│   └── note.dart            # Note data model
├── services/
│   ├── auth_service.dart    # Firebase Auth operations
│   └── notes_service.dart   # Firestore CRUD operations
├── providers/
│   ├── auth_provider.dart   # Authentication state management
│   └── notes_provider.dart  # Notes state management
├── screens/
│   ├── auth_wrapper.dart    # Authentication routing
│   ├── login_screen.dart    # Login/signup UI
│   └── notes_screen.dart    # Main notes interface
└── widgets/
    ├── note_item.dart       # Individual note display
    └── add_edit_note_dialog.dart # Note creation/editing
```

## App Flow

### Authentication Flow
1. **App Launch** → AuthWrapper checks authentication state
2. **Not Authenticated** → LoginScreen displays
3. **User Signs Up/In** → AuthProvider manages state
4. **Authentication Success** → Navigate to NotesScreen

### Notes Management Flow
1. **Notes Screen Load** → Fetch notes from Firestore
2. **Empty State** → Display helpful message with add button
3. **Add Note** → Show dialog → Save to Firestore → Update UI
4. **Edit Note** → Show prefilled dialog → Update Firestore → Refresh UI
5. **Delete Note** → Confirm dialog → Remove from Firestore → Update UI

## Testing the App

### Manual Testing Checklist

#### Authentication
- [ ] Sign up with new email/password
- [ ] Sign in with existing credentials
- [ ] Form validation (invalid email, short password)
- [ ] Sign out functionality
- [ ] Persistent authentication state

#### Notes CRUD
- [ ] Add new note
- [ ] Edit existing note
- [ ] Delete note with confirmation
- [ ] Empty state display
- [ ] Loading states during operations
- [ ] Success/error notifications

#### UI/UX
- [ ] Responsive design on different screen sizes
- [ ] Smooth navigation between screens
- [ ] Proper keyboard handling
- [ ] Accessibility features

## Deployment

### iOS App Store (Future)
1. Configure app signing in Xcode
2. Update app icons and launch screens
3. Build release version: `flutter build ios --release`
4. Archive and upload via Xcode

### Firebase Security Rules (Production)
Update Firestore rules for production:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{document} {
      allow read, write: if request.auth != null && 
                         request.auth.uid == resource.data.userId;
    }
  }
}
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-feature`
3. Commit changes: `git commit -am 'Add new feature'`
4. Push to branch: `git push origin feature/new-feature`
5. Submit pull request


## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Verify all prerequisites are met
3. Ensure Firebase configuration is correct
4. Check Flutter doctor output: `flutter doctor -v`
5. Review build logs for specific error messages

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Provider State Management](https://pub.dev/packages/provider)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

---


```

This README provides comprehensive documentation covering all build steps, architecture details, and troubleshooting guidance. The architecture diagram shows the clean separation between presentation, business, and data layers that your app follows.